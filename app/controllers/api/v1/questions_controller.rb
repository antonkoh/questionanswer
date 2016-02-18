class Api::V1::QuestionsController < Api::V1::BaseController



  authorize_resource



  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    @question = Question.find(params[:id])
    render json: @question
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_resource_owner
    if @question.save
      render json: @question
    else
      render json: {errors: @question.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private
  def question_params
    params.require(:question).permit(:title, :body)
  end


end