class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    AnswersMailer.notify_question_author(answer).deliver_later
  end
end
