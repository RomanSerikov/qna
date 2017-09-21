require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :user }
  it { should have_db_column(:user_id) }
  it { should belong_to :commentable }
end
