require 'rails_helper'

RSpec.describe "Questions API" do
  describe "GET /index" do
    context "unauthorized" do
      it 'returns 401 status has no access token' do
        get '/api/v1/questions', format: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns 401 status has incorrect access token' do
        get '/api/v1/questions', format: :json, acces_token: '1234'
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "authorized" do
      let(:access_token) {create(:access_token)}
      let!(:questions) {create_list(:question, 2)}
      let(:question) {questions.first}
      let!(:answer) {create(:answer, question: question)}

      before do
        get '/api/v1/questions', format: :json, access_token: access_token.token
      end

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id body title created_at updated_at).each do |attr|
        it "question contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr).to_json).at_path("questions/0/#{attr}")
        end
      end

      context "answers" do
        it 'includes answers into question' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "answer contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end

      #
      # %w(id email created_at updated_at admin).each do |attr|
      #   it "contains #{attr}" do
      #     expect(response.body).to be_json_eql(me.send(attr).to_json).at_path(attr)
      #   end
      # end
      #
      # %w(password encrypted_password).each do |attr|
      #   it "does not contain #{attr}" do
      #     expect(response.body).to_not have_json_path(attr)
      #   end
      # end
    end


  end

  describe "GET /questions/#" do
    let(:question) {create(:question)}
    let(:url) {"/api/v1/questions/#{question.id}"}
    let!(:attachments) {create_list(:attachment, 2, attachmentable_id: question.id, attachmentable_type: 'Question')}
    let!(:attachment) {attachments.first}

    context "unauthorized" do
      it 'returns 401 status has no access token' do
        get url, format: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns 401 status has incorrect access token' do
        get url, format: :json, acces_token: '1234'
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "authorized" do
      let(:access_token) {create(:access_token)}

      before do
        get url, format: :json, access_token: access_token.token
      end

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end


      %w(id body title created_at updated_at).each do |attr|
        it "question contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr).to_json).at_path("question/#{attr}")
        end
      end

      it 'returns list of attachments' do
        expect(response.body).to have_json_size(2).at_path("question/attachments")
      end


       %w(id created_at updated_at).each do |attr|
         it "attachment contains #{attr}" do
           expect(response.body).to be_json_eql(attachment.send(attr).to_json).at_path("question/attachments/0/#{attr}")
         end
       end

      it "attachment contains name" do
        expect(response.body).to be_json_eql(attachment.file.filename.to_json).at_path("question/attachments/0/name")
      end

      it "attachment contains url" do
        expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("question/attachments/0/url")
      end
    end


  end
end