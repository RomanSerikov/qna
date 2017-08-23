require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user)     { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer)   { create(:answer, question: question, user: user) }

  describe 'GET #new' do
    sign_in_user

    before { get :new, params: { question_id: question } }

    it 'assings new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }
          .to change(@user.answers, :count).by(1)
      end

      it 'render create template' do 
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }, format: :js }
          .to_not change(Answer, :count)
      end

      it 're-renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    context 'answer owner' do
      before { allow(controller).to receive(:current_user).and_return(user) }

      it 'changes answer attributes' do
        patch :update, params: { question_id: question, id: answer, answer: { body: 'NewBody' } }, 
              format: :js
        answer.reload  
        expect(answer.body).to eq 'NewBody'
      end

      it 'renders update template' do
        patch :update, 
              params: { question_id: question, id: answer, answer: attributes_for(:answer) }, 
              format: :js
        expect(response).to render_template :update
      end
    end

    context 'answer non-owner' do
      let(:another_user)   { create(:user) }
      let(:another_answer) { create(:answer, question: question, user: another_user) }

      it 'tries to change answer attributes' do
        patch :update, 
              params: { question_id: question, id: another_answer, answer: { body: 'NewBody' } }, 
              format: :js
        answer.reload

        expect(another_answer.body).to_not eq 'NewBody'
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    before { answer }

    context 'answer owner' do
      before { allow(controller).to receive(:current_user).and_return(user) }

      it 'deletes answer' do
        expect { delete :destroy, params: { question_id: question, id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question show view' do
        delete :destroy, params: { question_id: question, id: answer }
        expect(response).to redirect_to question
      end
    end

    context 'answer non-owner' do
      it 'tries to delete answer' do
        expect { delete :destroy, params: { question_id: question, id: answer } }.not_to change(Answer, :count)
      end

      it 're-renders question show view' do
        delete :destroy, params: { question_id: question, id: answer }
        expect(response).to render_template 'questions/show'
      end
    end
  end
end
