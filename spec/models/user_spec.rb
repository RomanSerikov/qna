require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#owner_of?' do
    let(:owner)     { create(:user) }
    let(:not_owner) { create(:user) }
    let(:question)  { create(:question, user: owner) }

    it 'returns true when user is owner' do
      expect(owner.owner_of?(question)).to be true
    end

    it 'return false when user is not owner' do
      expect(not_owner.owner_of?(question)).to be false
    end
  end
end
