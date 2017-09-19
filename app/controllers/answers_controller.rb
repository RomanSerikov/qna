class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:create]
  before_action :set_answer, only: [:update, :destroy, :best]
  after_action  :publish_answer, only: [:create]

  include Voted

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      flash.now[:notice] = 'Your answer succefully created.'
    else
      flash.now[:notice] = 'Your answer was not created.'
    end
  end

  def update
    if current_user.owner_of?(@answer)
      @answer.update(answer_params)
      flash.now[:notice] = 'Your answer succefully updated'
    else
      flash.now[:notice] = 'Your answer was not updated'
    end
  end

  def best
    @question = @answer.question

    if current_user.owner_of?(@question)
      @answer.mark_best
      flash.now[:notice] = 'Your answer succefully marked as best.'
    else
      flash.now[:notice] = 'You are not the question author.'
    end
  end

  def destroy
    if current_user.owner_of?(@answer)
      @answer.destroy
      flash.now[:notice] = 'Your answer succefully deleted.'
    else
      flash.now[:notice] = 'You are not the answer author.'
    end
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

    attachments = []
    @answer.attachments.each do |a|
      attachments << { id: a.id, file_url: a.file.url, file_name: a.file.identifier }
    end

    data = {
      answer:             @answer,
      answer_user_id:     current_user.id,
      question_id:        @question.id,
      question_user_id:   @question.user_id,
      answer_rating:      @answer.rating,
      answer_attachments: attachments
    }

    ActionCable.server.broadcast("question_#{@answer.question.id}", data)
  end
end
