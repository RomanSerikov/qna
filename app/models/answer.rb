class Answer < ApplicationRecord
  include Votable
  include Commentable
  
  belongs_to :question
  belongs_to :user

  has_many :attachments, dependent: :destroy, as: :attachable
  
  validates :body, presence: :true
  validates :best, uniqueness: { scope: :question_id }, if: :best

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_commit :notice_subscribers, on: :create

  default_scope { order(best: :desc) }

  def mark_best
    transaction do
      question.answers.update_all(best: false)
      update(best: true)
    end
  end

  def prepare_attachments
    attachments.map { |a| { id: a.id, file_url: a.file.url, file_name: a.file.identifier } }
  end

  def broadcast_data
    { answer:             self,
      answer_user_id:     user.id,
      question_id:        question.id,
      question_user_id:   question.user_id,
      answer_rating:      rating,
      answer_attachments: prepare_attachments }
  end

  private

  def notice_subscribers
    NotifySubscribersJob.perform_later(self)
  end
end
