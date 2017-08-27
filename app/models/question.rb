class Question < ApplicationRecord
  belongs_to :user

  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy, as: :attachable
  
  validates :title, :body, presence: :true
end
