require 'rails_helper'

shared_examples 'voted' do
  resource_name = described_class.controller_name.singularize.to_sym

  let(:resource)        { create(resource_name) }
  let(:question)        { create(:question) }
  let(:resource_params) { { id: resource } }

  before do
    resource_params[:question_id] = question if resource_name == :answer
  end

  sign_in_user

  describe 'POST #voteup' do
    it 'increase votes by 1' do
      post :voteup, params: resource_params, format: :js
      expect(resource.rating).to eq(1)
    end
  end

  describe 'POST #votedown' do
    it 'decrease votes by 1' do
      post :votedown, params: resource_params, format: :js
      expect(resource.rating).to eq(-1)
    end
  end
end
