require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it { should belong_to(:user) }
  it { should have_db_column(:user_id) }
end
