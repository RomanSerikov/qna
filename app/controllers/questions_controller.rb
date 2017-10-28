class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :set_question, only: [:show, :update, :destroy]
  before_action :build_answer, only: [:show]

  after_action :publish_question, only: [:create]
  after_action :subscribe_user, only: [:create]

  respond_to :html

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with(@question)
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    @question = current_user.questions.create(question_params)
    respond_with(@question)
  end

  def update
    @question.update(question_params)
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def build_answer
    @answer = @question.answers.build
  end
  
  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end

  def subscribe_user
    Subscription.create(user: @question.user, question: @question)
  end
end
