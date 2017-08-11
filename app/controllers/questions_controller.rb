class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :set_question, only: [:show, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question succefully created.'
    else
      render :new
    end
  end

  def destroy
    if current_user.owner_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question succefully deleted.'
    else
      redirect_to questions_path, notice: 'You are not the question author.'
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end
  
  def question_params
    params.require(:question).permit(:title, :body)
  end
end
