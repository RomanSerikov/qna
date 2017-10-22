require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  let(:model) { create(described_class.to_s.underscore.to_sym) }
  let(:user)  { create(:user) }

  describe '#voteup' do
    it 'creates new vote' do
      expect { model.voteup(user) }.to change(model.votes, :count).by(1)
    end

    it 'change votes value by 1' do
      model.voteup(user)
      expect(model.votes.sum(:value)).to eq(1)
    end

    it 'destroys vote if one already exist' do
      2.times { model.voteup(user) }
      expect(model.votes.sum(:value)).to eq(0)
    end
  end

  describe '#votedown' do
    it 'creates new vote' do
      expect { model.votedown(user) }.to change(model.votes, :count).by(1)
    end

    it 'change votes value by -1' do
      model.votedown(user)
      expect(model.votes.sum(:value)).to eq(-1)
    end

    it 'destroys vote if one already exist' do
      2.times { model.votedown(user) }
      expect(model.votes.sum(:value)).to eq(0)
    end
  end

  describe '#rating' do
    let(:users) { create_list(:user, 3) }

    it 'shows the sum of all votes' do
      users.each { |u| model.voteup(u) }
      expect(model.rating).to eq(3)
    end
  end
end
