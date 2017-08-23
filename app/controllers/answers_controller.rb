class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question
  before_action :set_answer, only: [:update, :destroy]

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

  def destroy
    if current_user.owner_of?(@answer)
      @answer.destroy
      redirect_to @question, notice: 'Your answer succefully deleted.'
    else
      flash.now[:notice] = 'You are not the answer author.'
      render 'questions/show'
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
    params.require(:answer).permit(:body)
  end
end
