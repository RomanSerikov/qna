class SearchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_search_types

  authorize_resource class: false

  def new
  end

  def search
    redirect_to new_search_path if check_search_type
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

  def check_search_type
    @search_types.value?(search_params[:type])
  end
end
