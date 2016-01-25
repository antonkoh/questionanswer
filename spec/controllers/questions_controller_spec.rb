require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let (:q) {create(:question)}
  let (:user) {create(:user)}



  describe "GET #index" do
    before {get :index}
    it 'loads all questions' do
      questions = FactoryGirl.create_list(:question, 3)
      expect(assigns(:questions)).to eq questions
    end
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    before {get :show, id: q}
    it 'loads question from parameter' do
      expect(assigns(:question)).to eq q
    end
    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe "GET #new" do
    before do
      login(user)
      get :new
    end
    it 'initializes a new question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe "GET #edit" do
    before do
      login(user)
      get :edit, id: q
    end
    it 'loads a question' do
      expect(assigns(:question)).to eq q
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    before {login(user)}

    context "when saved successfully" do
      it 'creates new question in DB' do
        expect {post :create, question: FactoryGirl.attributes_for(:question)}.to change(Question, :count).by(1)
      end
      it 'redirects to show view' do
        post :create, question: FactoryGirl.attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end

    end
    context "when unsaved" do
      it 'does not save a question in DB' do
        expect {post :create, question: FactoryGirl.attributes_for(:invalid_question)}.to_not change(Question, :count)
      end
      it 'render new view' do
        post :create, question: FactoryGirl.attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end



  describe "PATCH #update" do
    before{login(user)}
    context "when saved successfully" do
      before do
        patch :update, id: q, question: {title: "New title", body: "New body"}
        q.reload
      end

      it 'updates question in DB' do
        expect(q.title).to eq "New title"
        expect(q.body).to eq "New body"
      end

      it 'redirects to show view' do
        expect(response).to redirect_to q
      end

    end
    context "when unsaved" do
      before do
        patch :update, id: q, question: {title: "", body: ""}
        q.reload
      end

      it 'does not update question in DB' do
        expect(q.title).to eq FactoryGirl.attributes_for(:question)[:title]
        expect(q.body).to eq FactoryGirl.attributes_for(:question)[:body]
      end

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      login(user)
      q
    end
    it 'removes question from DB' do
      expect{delete :destroy, id: q}. to change(Question, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, id: q
      expect(response).to redirect_to questions_path
    end

  end


end
