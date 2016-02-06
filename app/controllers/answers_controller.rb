class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:edit]
  before_action :load_answer, only: [:edit, :update, :destroy]
  before_action :check_edit_rights, only: [:edit]



  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @signed_in = false
    if user_signed_in?
       @answer.save
       @signed_in = true
    end
    # if @answer.save
    #   redirect_to @question
    # else
    #   @question.reload
    #   render 'questions/show'
    # end
  end

  def edit
  end

  def update
    respond_to do |format|
      format.js do
        @has_rights = false
        @signed_in = false
        if user_signed_in?
           @signed_in = true
           if current_user.can_edit?(@answer)
             @has_rights = true
             @answer.update(answer_params)
           end
        end
      end

      format.json do
        case
          when !user_signed_in?
            render json: {}, status: :unauthorized
          when !current_user.can_edit?(@answer)
            render json: {}, status: :forbidden
          when @answer.update(answer_params)
            render json: @answer
          else
            render json: @answer.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
    # if @answer.update(answer_params)
    #   redirect_to @answer.question
    # else
    #   render :edit
    # end
  end

  def destroy
    @has_rights = false
    @signed_in = false
    if user_signed_in?
      @signed_in = true
      if current_user.can_edit?(@answer)
        @has_rights = true
        @answer.destroy
      end
    end
  end



  private
  def answer_params
    params.require(:answer).permit(:body,:question_id, attachments_attributes: [:file])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def check_edit_rights
    unless user_signed_in? && current_user.can_edit?(@answer)
      redirect_to @answer.question, notice: 'You don\'t have rights to perform this action.'
    end
  end
end
