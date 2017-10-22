require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions)   { create_list(:question, 2) }
      let(:question)     { questions.first }
      let!(:answer)      { create(:answer, question: question) }

      before do 
        get '/api/v1/questions', params: { format: :json, access_token: access_token.token }
      end

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'question object contains short title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("questions/0/short_title")
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    it_behaves_like 'API Authenticable'
    
    let(:question) { create(:question) }

    context 'authorized' do
      it_behaves_like 'API Attachable'
      it_behaves_like 'API Commentable'

      let(:access_token) { create(:access_token) }
      let!(:comment)     { create(:question_comment, commentable: question) }
      let!(:attachment)  { create(:attachment, attachable: question) }
      let(:subj)         { 'question' }
      
      before do 
        get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token }
      end

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      it 'returns 201 status' do
        post "/api/v1/questions", params: { 
          format: :json, access_token: access_token.token, question: attributes_for(:question)
        }
        expect(response.status).to eq 201
      end

      it 'saves the new question in the database' do
        expect { post "/api/v1/questions", params: {
          format: :json, access_token: access_token.token, question: attributes_for(:question)
        }}.to change(Question, :count).by(1)
      end

      context 'with invalid attributes' do
        it 'returns 422 status' do
          post "/api/v1/questions", params: { 
            format: :json, access_token: access_token.token,
            question: attributes_for(:invalid_question)
          }
          expect(response.status).to eq 422
        end

        it 'does not save question' do
          expect { post "/api/v1/questions", params: {
            format: :json, access_token: access_token.token, 
            question: attributes_for(:invalid_question)
          }}.to_not change(Question, :count)
        end
      end
    end

    def do_request(options = {})
      post "/api/v1/questions", params: { format: :json, question: attributes_for(:question) }.merge(options)
    end
  end
end
