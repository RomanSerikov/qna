class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true, optional: true
  belongs_to :user

  validate :user_can_vote_only_once

  private

  def user_can_vote_only_once
    if Vote.where(user_id: user).where(votable_id: votable).exists?
      errors.add(:votes_count, "can't be more than one")
    end
  end
end
