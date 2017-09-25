class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :set_question, only: [:create]
  before_action :set_answer, only: [:update, :destroy, :best]

  after_action :publish_answer, only: [:create]

  respond_to :js

  def create
    @answer = current_user.answers.create(answer_params.merge(question_id: @question.id))
    respond_with(@answer)
  end

  def update
    @answer.update(answer_params) if current_user.owner_of?(@answer)
  end

  def best
    respond_with(@answer.mark_best) if current_user.owner_of?(@answer.question)
  end

  def destroy
    respond_with(@answer.destroy) if current_user.owner_of?(@answer)
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast("question_#{@answer.question.id}", @answer.broadcast_data)
  end
end
