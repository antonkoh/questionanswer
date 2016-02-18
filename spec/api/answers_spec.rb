require 'rails_helper'

RSpec.describe "Answers API" do
  describe "GET /question/#/answers" do
  let!(:question) {create(:question)}
  let!(:answers) {create_list(:answer, 2, question: question)}
  let(:answer) {answers.first}
  let(:url) {"/api/v1/questions/#{question.id}/answers/"}

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

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2).at_path("answers")
      end

      %w(id body created_at updated_at).each do |attr|
        it "question contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr).to_json).at_path("answers/0/#{attr}")
        end
      end




    end


  end

  describe "GET /answers/#" do
    let(:answer) {create(:answer)}
    let(:url) {"/api/v1/answers/#{answer.id}"}
    let!(:attachments) {create_list(:attachment, 2, attachmentable_id: answer.id, attachmentable_type: 'Answer')}
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


      %w(id body created_at updated_at).each do |attr|
        it "question contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr).to_json).at_path("answer/#{attr}")
        end
      end

      it 'returns list of attachments' do
        expect(response.body).to have_json_size(2).at_path("answer/attachments")
      end


      %w(id created_at updated_at).each do |attr|
        it "attachment contains #{attr}" do
          expect(response.body).to be_json_eql(attachment.send(attr).to_json).at_path("answer/attachments/0/#{attr}")
        end
      end

      it "attachment contains name" do
        expect(response.body).to be_json_eql(attachment.file.filename.to_json).at_path("answer/attachments/0/name")
      end

      it "attachment contains url" do
        expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("answer/attachments/0/url")
      end
    end


  end
end