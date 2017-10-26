class AnswersMailer < ApplicationMailer
  def notify_question_author(answer)
    @question = answer.question
    mail to: answer.question.user.email
  end
end
