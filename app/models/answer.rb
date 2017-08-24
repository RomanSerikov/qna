class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  
  validates :body, presence: :true
  validates :best, uniqueness: { scope: :question_id }, if: :best

  default_scope { order(best: :desc) }

  def mark_best
    question.answers.where(best: true).update_all(best: false)
    self.update(best: true)
  end
end
