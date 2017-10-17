class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource

  before_action :set_question, only: [:index, :create]

  def index
    @answers = @question.answers
    respond_with @answers, each_serializer: AnswerCollectionSerializer
  end

  def show
    @answer = Answer.find(params[:id])
    respond_with @answer
  end

  def create
    @answer = current_resource_owner.answers.create(answer_params.merge(question_id: @question.id))
    respond_with @answer
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
