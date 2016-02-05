require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  let(:user) {create(:user)}
  let(:other_user) {create(:user)}
  let(:q) {create(:question, user: user)}
  let(:a) {create(:attachment, attachmentable_id: q.id, attachmentable_type: 'Question')}


  describe "DELETE #destroy" do
    context "author" do
      before do
        login(user)
        a
      end

      it 'removes attachment from DB' do
        expect{delete :destroy, id: a, format: :js}.to change(Attachment, :count).by(-1)
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

    end
  end

end



