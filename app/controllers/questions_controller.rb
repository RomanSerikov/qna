class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :set_question, only: [:show, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question succefully created.'
    else
      render :new
    end
  end

  def update
    if current_user.owner_of?(@question)
      @question.update(question_params)
      flash.now[:notice] = 'Your question succefully updated.'
    else
      flash.now[:notice] = 'Your question was not updated.'
    end
  end

  def destroy
    if current_user.owner_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question succefully deleted.'
    else
      redirect_to @question, notice: 'You are not the question author.'
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end
  
  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
