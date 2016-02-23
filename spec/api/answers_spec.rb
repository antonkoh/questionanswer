require 'rails_helper'

RSpec.describe "Answers API" do
  describe "GET /question/#/answers" do
    let!(:question) {create(:question)}
    let!(:answers) {create_list(:answer, 2, question: question)}
    let(:url) {"/api/v1/questions/#{question.id}/answers/"}
    let(:method) {:get}


    it_behaves_like "API Authenticable"

    context "authorized" do
      let(:access_token) {create(:access_token)}

      before do
        do_request(method,url, access_token: access_token.token)
      end

      context 'answers list' do
        it_behaves_like "API List Contents", 'id body created_at updated_at votes_sum' do
          let(:contents) {answers}
        end
      end
    end


  end



  describe "GET/answers/#" do
    let(:answer) {create(:answer)}
    let(:url) {"/api/v1/answers/#{answer.id}"}
    let(:method) {:get}
    let!(:attachments) {create_list(:attachment, 2, attachmentable_id: answer.id, attachmentable_type: 'Answer')}
    let!(:attachment) {attachments.first}

    it_behaves_like "API Authenticable"

    context "authorized" do
      let(:access_token) {create(:access_token)}

      before do
        do_request(method,url, access_token: access_token.token)
      end

      context 'answer item' do
        it_behaves_like "API Single Contents", 'id body created_at updated_at votes_sum' do
          let(:single) {answer}
        end
      end

      context 'attachments for answer' do

        it_behaves_like "API List Contents", 'id created_at updated_at' do
          let(:contents) {answer.attachments}
          let(:substitute_path_prefix) {"answer"}
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
end