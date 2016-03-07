require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  let(:user) {create(:user)}
  let(:other_user) {create(:user)}
  let(:q) {create(:question, user: user)}
  let(:answer) {create(:answer, user: user)}



  describe "DELETE #destroy" do

    context "for question" do
      let(:a) {create(:attachment, attachmentable_id: q.id, attachmentable_type: 'Question')}

      context "author" do
        before do
          login(user)
          a
        end

        it 'removes attachment from DB' do
          expect{delete :destroy, id: a, format: :js}.to change(Attachment, :count).by(-1)
        end

        it 'renders destroy attachment template in JS' do
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
          expect{delete :destroy, id: a, format: :js}.to_not change(Attachment, :count)
        end

        it 'renders unauthorized message in JS' do
          delete :destroy, id: a, format: :js
          it_renders_JS_unauthorized
        end

      end

      context "guest" do

        before {a}
        it 'does not remove a question from DB' do
          expect{delete :destroy, id: a, format: :js}.to_not change(Attachment, :count)
        end

        it 'returns 401 response' do
          delete :destroy, id:a, format: :js
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context "for answer" do
      let(:a) {create(:attachment, attachmentable_id: answer.id, attachmentable_type: 'Answer')}

      context "author" do
        before do
          login(user)
          a
        end

        it 'removes attachment from DB' do
          expect{delete :destroy, id: a, format: :js}.to change(Attachment, :count).by(-1)
        end

        it 'renders remove attachment template in JS' do
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
          expect{delete :destroy, id: a, format: :js}.to_not change(Attachment, :count)
        end

        it 'renders unauthorized message in JS' do
          delete :destroy, id: a, format: :js
          it_renders_JS_unauthorized
        end

      end

      context "guest" do
        before {a}
        it 'does not remove a question from DB' do
          expect{delete :destroy, id: a, format: :js}.to_not change(Attachment, :count)
        end

        it 'returns 401 response' do
          delete :destroy, id:a, format: :js
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end


  end

end



