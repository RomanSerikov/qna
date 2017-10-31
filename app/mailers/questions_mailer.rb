class QuestionsMailer < ApplicationMailer
  def notify(subscription)
    @question = subscription.question
    mail to: subscription.user.email
  end
end
