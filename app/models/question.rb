class Question < ApplicationRecord
  include Votable
  include Commentable
  
  belongs_to :user

  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy, as: :attachable
  has_many :subscriptions, dependent: :destroy
  
  validates :title, :body, presence: :true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_create :subscribe_author

  scope :digest, -> { where("created_at > ?", 1.day.ago) }

  private

  def subscribe_author
    Subscription.create(user: user, question: self)
  end
end
