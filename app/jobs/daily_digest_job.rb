class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    User.send_daily_digest if Question.digest.present?
  end
end
