class AnswersMailer < ApplicationMailer
  def notify(answer, user)
    @question = answer.question
    mail to: user.email
  end
end
