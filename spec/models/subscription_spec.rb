require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to(:user) }
  it { should have_db_column(:user_id) }
  it { should belong_to :question }
  it { should have_db_column :question_id }
end
