require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) {create(:user)}
  let(:other_user) {create(:user)}
  let (:q) {create(:question, user: user)}
  let (:a) {create(:answer, question: q, user: user)}




  describe "POST #create" do
    context "authenticated" do

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
      end

      context "when unsaved" do
        it 'does not save an answer to DB' do
          expect {post :create, question_id: q, answer: attributes_for(:invalid_answer), format: :js}.to_not change(Answer, :count)
        end

      end
    end

    context "guest" do
      it 'returns 401 status' do
        post :create, question_id: q, answer: attributes_for(:answer), format: :js
        expect(response).to have_http_status(:unauthorized)
      end

    end

  end




  describe "PATCH #update" do

    context "author signed in" do
      before do
        login(user)
      end

      context "when saved successfully" do
        before do
          @new_answer = attributes_for(:answer)
          patch :update, id:a, answer: @new_answer, format: :json
          a.reload
        end


        it 'updates answer in DB' do

          expect(a.body).to eq @new_answer[:body]
        end

        %w(id body created_at updated_at).each do |attr|
          it "renders answer in JSON with #{attr}" do
            expect(response.body).to be_json_eql(a.send(attr).to_json).at_path("answer/#{attr}")
          end
        end


      end

      context "when unsaved" do

        before do
          @old_body = a.body
          patch :update, id:a, answer: {body: ""}, format: :json
          a.reload
        end
        it 'does not update answer' do

          expect(a.body).to eq @old_body
        end

        it 'returns 422 status' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns errors in JSON' do
          expect(JSON.parse(response.body)["errors"]).to eq ["Body can't be blank"]
        end




      end
    end

    context "guest" do
      before do
        @new_answer = attributes_for(:answer)
        patch :update, id:a, answer: @new_answer, format: :json
        a.reload
      end


      it 'returns 401 status' do
        expect(response).to have_http_status(:unauthorized)
      end


      it 'does not update answer' do
        expect(a.body).to_not eq @new_answer[:body]
      end


    end

    context "not owner signed in" do
      before do
        @current_answer = a
        login(other_user)
        patch :update, id: a, answer: attributes_for(:answer), format: :json
      end

      it 'returns 403 status' do
        expect(response).to have_http_status(:forbidden)
      end


      it 'does not update answer' do
        expect(a).to eq @current_answer
      end
    end

  end

  describe "DELETE #destroy" do
    context "guest" do
      it 'returns 401 status' do
        a
        delete :destroy, id: a, format: :js
        expect(response).to have_http_status(:unauthorized)
      end

    end

    context "author" do
      before do
        login(user)
        a
      end
      it 'removes question from DB' do
        expect{delete :destroy, id: a, format: :js}.to change(Answer, :count).by(-1)
      end

      it 'renders delete template in JS' do
        delete :destroy, id: a, format: :js
        expect(response).to render_template :destroy
      end
    end

    context "not author" do
      before do
        login(other_user)
        a
      end

      it 'does not remove a question from DB' do
        expect{delete :destroy, id: a, format: :js}.to_not change(Answer, :count)
      end

      it 'returns 403 status' do
        delete :destroy, id: a, format: :js
        expect(response).to have_http_status(:forbidden)
      end

    end
  end

end
