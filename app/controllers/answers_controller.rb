class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :edit]
  before_action :load_answer, only: [:edit, :update]
  before_action :check_edit_rights, only: [:edit, :update]

  def new
    @answer = Answer.new
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @answer.update(answer_params)
      redirect_to @answer.question
    else
      render :edit
    end
  end



  private
  def answer_params
    params.require(:answer).permit(:body,:question_id)
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
