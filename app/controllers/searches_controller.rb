class SearchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_search_types, only: [:new]

  authorize_resource class: false

  def new
  end

  def create
    @search = model_klass.search search_params[:text]
    render :show
  end

  private

  def search_params
    params.require(:search).permit(:type, :text)
  end

  def set_search_types
    @search_types = { 
      thinking_sphinx: "Global", 
      question: "Question",
      comment: "Comment",
      answer: "Answer",
      user: "User"
    } 
  end

  def model_klass
    search_params[:type].to_s.camelize.constantize
  end
end
