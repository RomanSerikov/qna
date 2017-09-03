module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable

    def voteup(user)
      vote(1, user)
    end

    def votedown(user)
      vote(-1, user)
    end

    private

    def vote(value, user)
      votes.create!(value: value, user: user)
    end
  end
end
