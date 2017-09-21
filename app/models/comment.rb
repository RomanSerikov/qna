class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true, optional: true

  def prepare_data
    { commentable_id:   commentable_id,
      commentable_type: commentable_type.underscore,
      comment:          self }
  end

  def choose_type(commentable)
    commentable_type == 'Question' ? commentable.id : commentable.question_id
  end
end
