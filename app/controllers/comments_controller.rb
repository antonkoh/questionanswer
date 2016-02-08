class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable

  authorize_resource

  def new
    @comment = @commentable.comments.new
  end

  def create
    @comment = @commentable.comments.new(comment_params)
    if @commentable.is_a?(Answer)
      if @comment.save
        redirect_to question_path(@commentable.question_id)
      else
        render :new
      end

    else
      if @comment.save
        redirect_to @commentable
      else
        render :new
      end
    end
  end


  private

  def load_commentable
    resource, id = request.path.split('/')[1, 2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
