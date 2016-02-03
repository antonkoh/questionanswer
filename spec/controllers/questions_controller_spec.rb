require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let (:user) {create(:user)}
  let (:other_user) {create(:user)}
  let (:q) {create(:question, user: user)}


  describe "DELETE #destroy" do
    context "guest" do
      it 'redirects to sign in form' do
       delete :destroy, id: q
       expect(response).to redirect_to new_user_session_path
      end
    end

    context "author" do
      before do
        login(user)
        q
      end
      it 'removes question from DB' do
        expect{delete :destroy, id: q}.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, id: q
        expect(response).to redirect_to questions_path
      end
    end

    context "not author" do
      before do
        login(other_user)
        q
      end

      it 'does not remove a question from DB' do
        expect{delete :destroy, id: q}.to_not change(Question, :count)
      end

      it 'refreshes the form' do
        delete :destroy, id: q
        expect(response).to redirect_to q
      end

      it 'includes a flash notice' do
        delete :destroy, id: q
        expect(flash[:notice]).to eq 'You don\'t have rights to perform this action.'
      end
    end
  end



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

    it 'initializes an attachment for this question' do #because editing is in JS
      expect(assigns(:attachment)).to be_a_new(Attachment)
    end
  end

  describe "GET #new" do
    context "guest" do
      it 'redirects to sign in form' do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "authorized" do
      before do
        login(user)
        get :new
      end
      it 'initializes a new question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'initializes an attachment for new question' do
        expect(assigns(:attachment)).to be_a_new(Attachment)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end
  end

  describe "GET #edit" do
    context "guest" do
      it 'redirects to sign in form' do
        get :edit, id: q
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "author" do
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

    context "not author" do
      before do
        login(other_user)
        get :edit, id: q
      end
      it 'refreshes the question page' do
        expect(response).to redirect_to q
      end

      it 'includes a flash notice' do
        expect(flash[:notice]).to eq 'You don\'t have rights to perform this action.'
      end
    end
  end

  describe "POST #create" do
    context "guest" do
      it 'redirects to sign in form' do
        post :create
        expect(response).to redirect_to new_user_session_path
      end
    end


    context "authorized" do
      before {login(user)}

      context "when saved successfully" do
        it 'creates new question in DB for the current user' do
          expect {post :create, question: FactoryGirl.attributes_for(:question)}.to change(user.questions, :count).by(1)
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
  end



  describe "PATCH #update" do
    context "guest" do
      before do
        @current_question = q
        patch :update, id: q, question: attributes_for(:question), format: :json
        q.reload
      end
      # it 'redirects to sign in form' do
      #
      #   expect(response).to redirect_to new_user_session_path
      # end

      it 'does not update answer' do
        expect(q).to eq @current_question
      end
    end

    context "not author" do
      before do
        login(other_user)
        @current_question = q
        patch :update, id: q, question: attributes_for(:question), format: :json
        q.reload
      end
      it 'does not update a question' do
        expect(q).to eq @current_question
      end
      # it 'refreshes the form' do
      #   expect(response).to redirect_to q
      # end
      #
      # it 'includes a flash notice' do
      #   expect(flash[:notice]).to eq 'You don\'t have rights to perform this action.'
      # end
    end

    context "author" do
      before{login(user)}
      context "when saved successfully" do
        before do
          patch :update, id: q, question: {title: "New title", body: "New body"}, format: :json
          q.reload
        end

        it 'updates question in DB' do
          expect(q.title).to eq "New title"
          expect(q.body).to eq "New body"
        end

        # it 'redirects to show view' do
        #   expect(response).to redirect_to q
        # end

      end
      context "when unsaved" do
        before do
          @old_title = q.title
          @old_body = q.body
          patch :update, id: q, question: {title: "", body: ""}, format: :json
          q.reload
        end

        it 'does not update question in DB' do
          expect(q.title).to eq @old_title
          expect(q.body).to eq @old_body
        end

        # it 'renders edit view' do
        #   expect(response).to render_template :edit
        # end
      end
    end
  end



end
