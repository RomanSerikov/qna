class CommentsController < ApplicationController
  before_action :set_commentable, only: [:create]

  after_action :publish_comment, only: [:create]

  respond_to :json

  def create
    @comment = @commentable.comments.create(comment_params.merge(user: current_user))
    respond_with @comment, json: @comment 
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    if params[:question_id].present?
      @commentable = Question.find(params[:question_id])
    elsif params[:answer_id].present?
      @commentable = Answer.find(params[:answer_id])
    end
  end

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast(
      "comments_for_#{@comment.choose_type(@commentable)}",
      @comment.broadcast_data
    )
  end
end
