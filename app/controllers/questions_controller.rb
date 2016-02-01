class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :destroy]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :check_edit_rights, only: [:edit, :destroy]


  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      redirect_to @question, notice: 'Your question has been created'
    else
      render :new
    end
  end

  def update
    @has_rights = false
    @signed_in = false
    if user_signed_in?
      @signed_in = true
      if current_user.can_edit?(@question)
        @has_rights = true
        @question.update(question_params)
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
    params.require(:question).permit(:title, :body)
  end

  def check_edit_rights
    unless user_signed_in? && current_user.can_edit?(@question)
      redirect_to @question, notice: 'You don\'t have rights to perform this action.'
    end
  end

end
