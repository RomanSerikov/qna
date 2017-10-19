require 'rails_helper'

shared_examples 'voted' do
  resource_name = described_class.controller_name.singularize.to_sym

  sign_in_user

  let(:resource)              { create(resource_name) }
  let(:resource_params)       { { id: resource } }
  let(:owned_resource)        { create(resource_name, user: @user) }
  let(:owned_resource_params) { { id: owned_resource } }
  let(:question)              { create(:question) }
  
  before do
    if resource_name == :answer
      resource_params[:question_id]       = question 
      owned_resource_params[:question_id] = question
    end
  end

  describe 'POST #voteup' do
    context 'resource non-owner' do
      it 'increase rating by 1' do
        post :voteup, params: resource_params, format: :js
        expect(resource.rating).to eq(1)
      end

      it 'saves the new vote in the database' do
        expect { post :voteup, params: resource_params, format: :js }
          .to change(resource.votes, :count).by(1)
      end
    end

    context 'resource owner' do
      it 'try to increase rating by 1' do
        post :voteup, params: owned_resource_params, format: :js
        expect(owned_resource.rating).to eq(0)
      end

      it 'try to saves the new vote in the database' do
        expect { post :voteup, params: owned_resource_params, format: :js }
          .to change(owned_resource.votes, :count).by(0)
      end
    end
  end

  describe 'POST #votedown' do
    context 'resource non-owner' do
      it 'decrease rating by 1' do
        post :votedown, params: resource_params, format: :js
        expect(resource.rating).to eq(-1)
      end

      it 'saves the new vote in the database' do
        expect { post :votedown, params: resource_params, format: :js }
          .to change(resource.votes, :count).by(1)
      end
    end

    context 'resource owner' do
      it 'try to decrease rating by 1' do
        post :votedown, params: owned_resource_params, format: :js
        expect(owned_resource.rating).to eq(0)
      end

      it 'try to saves the new vote in the database' do
        expect { post :votedown, params: owned_resource_params, format: :js }
          .to change(owned_resource.votes, :count).by(0)
      end
    end
  end
end
