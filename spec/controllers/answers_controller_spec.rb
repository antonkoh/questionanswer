require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let (:q) {create(:question)}
  let(:user) {create(:user)}



  describe "GET #new" do
    before do
      login(user)
      get :new, question_id: q
    end

    it 'initializes a new answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    before {login(user)}
    it 'loads a question' do
      post :create,question_id: q, answer: attributes_for(:answer)
      expect(assigns(:question)).to eq q
    end

    context "when saved successfully" do
      it 'creates new answer in DB for the given question' do
        expect {post :create, question_id: q, answer: attributes_for(:answer)}.to change(q.answers, :count).by(1)
      end
      it 'redirects to show view for question' do
        post :create,question_id: q, answer: attributes_for(:answer)
        expect(response).to redirect_to q
      end

    end
    context "when unsaved" do
      it 'does not save an answer to DB' do
        expect {post :create, question_id: q, answer: attributes_for(:invalid_answer)}.to_not change(Answer, :count)
      end
      it 'renders new view' do
        post :create, question_id: q, answer: attributes_for(:invalid_answer)
        expect(response).to render_template :new
      end
    end
  end

end
