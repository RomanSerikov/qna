class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many :attachments, dependent: :destroy, as: :attachable
  
  validates :body, presence: :true
  validates :best, uniqueness: { scope: :question_id }, if: :best

  accepts_nested_attributes_for :attachments

  default_scope { order(best: :desc) }

  def mark_best
    transaction do
      question.answers.update_all(best: false)
      update(best: true)
    end
  end
end
