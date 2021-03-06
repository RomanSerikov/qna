require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like 'voted'

  let(:user)     { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2, user: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user
    
    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }
          .to change(@user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }
          .to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    context 'question owner' do
      before { allow(controller).to receive(:current_user).and_return(user) }
      
      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'NewTitle', body: 'NewBody' } }, 
              format: :js
        question.reload
        
        expect(question.title).to eq 'NewTitle'
        expect(question.body).to eq 'NewBody'
      end

      it 'renders update template' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'question non-owner' do
      let(:another_user)     { create(:user) }
      let(:another_question) { create(:question, user: another_user) }

      it 'tries to change question attributes' do
        patch :update, params: { id: another_question, question: { title: 'NewTitle', body: 'NewBody' } }, format: :js
        question.reload

        expect(another_question.title).to_not eq 'NewTitle'
        expect(another_question.body).to_not eq 'NewBody'
      end

      it 'is forbidden' do
        patch :update, params: { id: another_question, question: attributes_for(:question) }, 
              format: :js
        expect(response).to be_forbidden
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    before { question }

    context 'question owner' do
      before { allow(controller).to receive(:current_user).and_return(user) }

      it 'deletes question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'question non-owner' do
      it 'tries to delete question' do
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
      end
    end
  end
end
