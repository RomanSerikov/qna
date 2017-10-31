class DailyMailer < ApplicationMailer
  def digest(user)
    @questions = Question.digest
    mail to: user.email
  end
end
