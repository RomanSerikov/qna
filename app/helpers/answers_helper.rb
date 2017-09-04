module AnswersHelper
  def can_mark_best?(question, answer)
    user_signed_in? && current_user.owner_of?(question) && !answer.best
  end

  def can_vote?(answer)
    user_signed_in? && !current_user.owner_of?(answer)
  end
end
