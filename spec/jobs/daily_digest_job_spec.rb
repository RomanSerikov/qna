require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  it 'sends daily digets' do
    expect(User).to receive(:send_daily_digest)
    DailyDigestJob.perform_now
  end
end
