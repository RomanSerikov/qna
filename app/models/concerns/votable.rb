module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def voteup(user)
    vote(1, user)
  end

  def votedown(user)
    vote(-1, user)
  end

  def rating
    votes.sum(:value)
  end

  private

  def vote(value, user)
    if votes.where(user: user).where(value: value).exists?
      votes.where(user: user).first.destroy
    else
      votes.create!(value: value, user: user)
    end
  end
end
