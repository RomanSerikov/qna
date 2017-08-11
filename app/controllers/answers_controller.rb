class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @question, notice: 'Your answer succefully created.'
    else
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])

    if current_user.owner_of?(@answer)
      @answer.destroy
      redirect_to @question, notice: 'Your answer succefully deleted.'
    else
      flash.now[:notice] = 'You are not the answer author.'
      render 'questions/show'
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
