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
end