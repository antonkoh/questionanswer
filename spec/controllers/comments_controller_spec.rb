require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let (:q) {create(:question)}
  let (:a) {create(:answer, question: q)}


  describe "GET #new" do
    context "for question" do
      before do
        get :new, question_id: q.id
      end
      it 'initializes a new comment' do
        expect(assigns(:comment)).to be_a_new(Comment)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    context "for answer" do
      before do
        get :new, answer_id: a.id
      end
      it 'initializes a new comment' do
        expect(assigns(:comment)).to be_a_new(Comment)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end
  end

  describe "POST #create" do
    context "for question" do
      context "when saved successfully" do
        it 'creates new comment in DB for question' do
          expect {post :create, comment: attributes_for(:comment), question_id: q.id}.to change(q.comments, :count).by(1)
        end
        it 'redirects to question show view' do
          post :create, comment: attributes_for(:comment), question_id: q.id
          expect(response).to redirect_to question_path(q)
        end

      end
      context "when unsaved" do
        it 'does not save a comment in DB' do
          expect {post :create, comment: attributes_for(:invalid_comment), question_id: q.id}.to_not change(Comment, :count)
        end
        it 'render new view' do
          post :create, comment: attributes_for(:invalid_comment), question_id: q.id
          expect(response).to render_template :new
        end
      end
    end

    context "for answer" do
      context "when saved successfully" do
        it 'creates new comment in DB for answer' do
          expect {post :create, comment: attributes_for(:comment), answer_id: a.id}.to change(a.comments, :count).by(1)
        end
        it 'redirects to question show view' do
          post :create, comment: attributes_for(:comment), answer_id: a.id
          expect(response).to redirect_to question_path(q)
        end

      end
      context "when unsaved" do
        it 'does not save a comment in DB' do
          expect {post :create, comment: attributes_for(:invalid_comment), answer_id: a.id}.to_not change(Comment, :count)
        end
        it 'render new view' do
          post :create, comment: attributes_for(:invalid_comment), answer_id: a.id
          expect(response).to render_template :new
        end
      end
    end

  end


end
