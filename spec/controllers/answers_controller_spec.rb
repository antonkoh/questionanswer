require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) {create(:user)}
  let(:other_user) {create(:user)}
  let (:q) {create(:question, user: user)}
  let (:a) {create(:answer, question: q, user: user)}




  describe "POST #create" do
    context "user signed in" do

      before {login(user)}
      it 'loads a question' do
        post :create,question_id: q, answer: attributes_for(:answer), format: :js
        expect(assigns(:question)).to eq q
      end

      context "when saved successfully" do
        it 'creates new answer in DB for the given question' do
          expect {post :create, question_id: q, answer: attributes_for(:answer), format: :js}.to change(q.answers, :count).by(1)
        end

        it 'creates new answer in DB for the given user' do
          expect {post :create, question_id: q, answer: attributes_for(:answer), format: :js}.to change(user.answers, :count).by(1)
        end

        # it 'adds the answer to the page' do
        #   post :create,question_id: q, answer: attributes_for(:answer), format: :js
        #   expect(response).to render_template 'answer'
        # end

      end
      context "when unsaved" do
        it 'does not save an answer to DB' do
          expect {post :create, question_id: q, answer: attributes_for(:invalid_answer), format: :js}.to_not change(Answer, :count)
        end
        # it 're-renders question view' do
        #   post :create, question_id: q, answer: attributes_for(:invalid_answer), format: :js
        #   expect(response).to render_template 'questions/show'
        # end
      end
    end

    context "unauthorized user" do
      # it 'redirects to sign in form' do
      #
      #   post :create, question_id: q, format: :js
      #   expect(response).to redirect_to new_user_session_path
      # end
    end

  end

  describe "GET #edit" do
    context "author signed in" do
      before do
        login(user)
        get :edit, id: a
      end

      it 'loads an answer' do
        expect(assigns(:answer)).to eq a
      end

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end

    context "not author signed in" do
      before do
        login(other_user)
        get :edit, id: a
      end
      it 'refreshes the question page' do
        expect(response).to redirect_to a.question
      end
      it 'includes flash notice' do
        expect(flash[:notice]). to eq 'You don\'t have rights to perform this action.'
      end
    end

    context "unauthorized user" do
      before {get :edit, id: a}
      it 'redirects to sign in form' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "PATCH #update" do

    context "author signed in" do
      before do
        login(user)
      end

      context "when saved successfully" do

        it 'updates answer in DB' do
          @new_answer = attributes_for(:answer)
          patch :update, id:a, answer: @new_answer, format: :js
          a.reload
          expect(a.body).to eq @new_answer[:body]
        end

        # it 'redirects to show view for question' do
        #   patch :update, id:a, answer: attributes_for(:answer)
        #   expect(response).to redirect_to a.question
        # end
      end

      context "when unsaved" do
        it 'does not update answer' do
          @old_body = a.body
          patch :update, id:a, answer: {body: ""}, format: :js
          a.reload
          expect(a.body).to eq @old_body
        end

        # it 'renders edit view' do
        #   patch :update, id: a, answer: {body: ""}
        #   expect(response).to render_template :edit
        # end
      end
    end

    context "unauthorized user" do

      # it 'redirects to sign in form' do
      #   patch :update, id:a, answer: attributes_for(:answer)
      #   expect(response).to redirect_to new_user_session_path
      # end

      it 'does not update answer' do
        @new_answer = attributes_for(:answer)
        patch :update, id:a, answer: @new_answer, format: :js
        a.reload
        expect(a.body).to_not eq @new_answer[:body]
      end


    end

    context "not owner signed in" do
      before do
        @current_answer = a
        login(other_user)
        patch :update, id: a, answer: attributes_for(:answer), format: :js
      end

      # it 'refreshes the question form' do
      #   expect(response).to redirect_to q
      # end
      #
      # it 'includes a flash notice' do
      #   expect(flash[:notice]).to eq 'You don\'t have rights to perform this action.'
      # end

      it 'does not update answer' do
        expect(a).to eq @current_answer
      end
    end

  end

  describe "DELETE #destroy" do
    # context "guest" do
    #   it 'redirects to sign in form' do
    #     delete :destroy, id: a
    #     expect(response).to redirect_to new_user_session_path
    #   end
    # end

    context "author" do
      before do
        login(user)
        a
      end
      it 'removes question from DB' do
        expect{delete :destroy, id: a, format: :js}.to change(Answer, :count).by(-1)
      end

      # it 'refreshes questionx' do
      #   delete :destroy, id: a
      #   expect(response).to redirect_to a.question
      # end


    end

    context "not author" do
      before do
        login(other_user)
        a
      end

      it 'does not remove a question from DB' do
        expect{delete :destroy, id: a, format: :js}.to_not change(Answer, :count)
      end
      #
      # it 'refreshes the form' do
      #   delete :destroy, id: a
      #   expect(response).to redirect_to q
      # end
      #
      # it 'includes a flash notice' do
      #   delete :destroy, id: a
      #   expect(flash[:notice]).to eq 'You don\'t have rights to perform this action.'
      # end
    end
  end

end
