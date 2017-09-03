require 'rails_helper'

shared_examples 'voted' do
  resource_name = described_class.controller_name.singularize.to_sym

  let(:user)     { create(:user) }
  let(:resource) { create(resource_name, user: user) }

  sign_in_user

  describe 'POST #voteup' do
    it 'increase votes by 1' do
      post :voteup, params: { id: resource }, format: :js
      expect(resource.votes.sum(:value)).to eq(1)
    end
  end

  describe 'POST #votedown' do
    it 'decrease votes by 1' do
      post :votedown, params: { id: resource }, format: :js
      expect(resource.votes.sum(:value)).to eq(-1)
    end
  end
end
