require 'rails_helper'

RSpec.describe "Questions API" do
  describe "GET /index" do
    let (:url) {'/api/v1/questions'}
    let(:method) {:get}

    it_behaves_like "API Authenticable"

    context "authorized" do
      let(:access_token) {create(:access_token)}
      let!(:questions) {create_list(:question, 2)}
      let!(:answer) {create(:answer, question: questions.first)}

      before do
        do_request(method,url,access_token: access_token.token)
      end

      context "questions list" do
        it_behaves_like "API List Contents", 'id body title created_at updated_at votes_sum' do
          let(:contents) {questions}
        end
      end

      context "answers in question" do
        it_behaves_like "API List Contents", 'id body created_at updated_at votes_sum' do
          let(:contents) {questions.first.answers}
          let(:substitute_path_prefix) {'questions/0'}
        end
      end
    end
  end

  describe "GET /questions/#" do
    let(:question) {create(:question)}
    let(:url) {"/api/v1/questions/#{question.id}"}
    let(:method) {:get}
    let!(:attachments) {create_list(:attachment, 2, attachmentable_id: question.id, attachmentable_type: 'Question')}

    it_behaves_like "API Authenticable"

    context "authorized" do
      let(:access_token) {create(:access_token)}

      before do
        do_request(method,url, access_token: access_token.token)
      end

       context 'question item' do
         it_behaves_like "API Single Contents", 'id body title created_at updated_at votes_sum' do
           let(:single) {question}
         end
       end


       context 'attachments in question' do
         it_behaves_like "API List Contents", 'id created_at updated_at' do
           let(:contents) {question.attachments}
           let(:substitute_path_prefix) {'question'}
         end


        it "attachment contains name" do
          expect(response.body).to be_json_eql(attachments.first.file.filename.to_json).at_path("question/attachments/0/name")
        end

        it "attachment contains url" do
          expect(response.body).to be_json_eql(attachments.first.file.url.to_json).at_path("question/attachments/0/url")
        end
     end
    end


  end

  describe "POST /questions" do

    let(:url) {'/api/v1/questions'}
    let(:method) {:post}
    let(:include_options) {{question:FactoryGirl.attributes_for(:question)}}
    let(:question) {double(Question, include_options[:question].merge(votes_sum: 0))}


    it_behaves_like "API Authenticable"


    context "authorized" do
      let(:me) {create(:user)}
      let(:access_token) {create(:access_token, resource_owner_id: me.id)}
      let(:with_invalid_options) {{question: FactoryGirl.attributes_for(:invalid_question), access_token: access_token.token}}

      context "when saved successfully" do

        it 'creates new question in DB for the current user' do
           expect {do_request(method,url,include_options.merge(access_token: access_token.token))}.to change(me.questions, :count).by(1)
        end

        context 'contents' do
          before do
            do_request(method,url,include_options.merge(access_token: access_token.token))
          end
          it_behaves_like "API Single Contents", 'body title votes_sum' do
            let(:single) {question}
            let(:substitute_single_name) {'question'}
          end
        end
      end

      context "when unsaved" do
        it 'does not save a question in DB' do
           expect {do_request(method,url,with_invalid_options)}.to_not change(Question, :count)
         end


        it 'returns 422 status' do
          do_request(method,url,with_invalid_options)
           expect(response).to have_http_status(:unprocessable_entity)
         end

        it 'renders errors' do
          do_request(method,url,with_invalid_options)
           expect(response.body).to have_json_size(2).at_path("errors")
         end
      end
    end
  end
end