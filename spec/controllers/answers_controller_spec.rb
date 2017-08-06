require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    let(:question) { create(:question) }

    context 'with valid attributes' do
      it 'saves new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }
          .to change(Answer, :count).by(1)
      end

      it 'redirects to question show view' do 
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
  end
end
