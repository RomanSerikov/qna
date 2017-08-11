require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  describe '#owner_of?' do
    let(:owner)     { create(:user) }
    let(:not_owner) { create(:user) }
    let(:question)  { create(:question, user: owner) }

    it 'correctly identify owner' do
      expect(owner.owner_of?(question)).to be true
      expect(not_owner.owner_of?(question)).to be false
    end
  end
end
