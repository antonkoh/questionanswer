class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :destroy, :update]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
 # before_action :check_edit_rights, only: [:edit, :destroy]

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @attachment = @question.attachments.new
    @answer_attachment = @answer.attachments.new
  end

  def new
    @question = Question.new
    @attachment = @question.attachments.new
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      PrivatePub.publish_to "/questions", new_question: @question
      redirect_to @question
    else
      @question.attachments = [Attachment.new]
      render :new
    end
  end

  def update
    respond_to do |format|
      format.js do
        @has_rights = false
        @signed_in = false
        if user_signed_in?
          @signed_in = true
          if current_user.can_edit?(@question)
            @has_rights = true
            @question.update(question_params)
          end
        end
      end

      format.json do
        case
          when !user_signed_in?
            render json: {}, status: :unauthorized
          when !current_user.can_edit?(@question)
            render json: {}, status: :forbidden
          when @question.update(question_params)
            render json: @question
          else
            render json: @question.errors.full_messages, status: :unprocessable_entity
        end
      end
    end

   # if @question.update(question_params)
   #   redirect_to @question
   # else
   #   render :edit
   #  end
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  private
  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

  # def check_edit_rights
  #   unless user_signed_in? && current_user.can_edit?(@question)
  #     redirect_to @question, notice: 'You don\'t have rights to perform this action.'
  #   end
  # end

end
