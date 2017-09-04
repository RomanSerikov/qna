module QuestionsHelper
  def can_vote?(question)
    user_signed_in? && !current_user.owner_of?(question)
  end
end
