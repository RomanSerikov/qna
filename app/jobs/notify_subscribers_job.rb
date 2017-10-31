class NotifySubscribersJob < ApplicationJob
  queue_as :default

  def perform(question)
    question.subscriptions.each do |subscription|
      QuestionsMailer.notify(subscription).deliver_later
    end
  end
end
