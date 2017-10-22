require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    let(:question) { create(:question) }

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers)     { create_list(:answer, 2, question: question) }

      before do 
        get "/api/v1/questions/#{question.id}/answers", params: {
          format: :json, access_token: access_token.token
        }
      end

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2).at_path("answers")
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          answers.reverse.each_with_index do |answer, id|
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/#{id}/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    it_behaves_like 'API Authenticable'

    let(:answer) { create(:answer) }

    context 'authorized' do
      it_behaves_like 'API Attachable'
      it_behaves_like 'API Commentable'

      let(:access_token) { create(:access_token) }
      let!(:comment)     { create(:answer_comment, commentable: answer) }
      let!(:attachment)  { create(:attachment, attachable: answer) }
      let(:subj)         { 'answer' }

      before do 
        get "/api/v1/answers/#{answer.id}", params: { 
          format: :json, access_token: access_token.token 
        }
      end

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like 'API Authenticable'

    let(:question) { create(:question) }

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      it 'returns 201 status' do
        post "/api/v1/questions/#{question.id}/answers", params: { 
          format: :json, access_token: access_token.token, answer: attributes_for(:answer)
        }
        expect(response.status).to eq 201
      end

      it 'saves the new answer in the database' do
        expect { post "/api/v1/questions/#{question.id}/answers", params: {
          format: :json, access_token: access_token.token, answer: attributes_for(:answer)
        }}.to change(Answer, :count).by(1)
      end

      context 'with invalid attributes' do
        it 'returns 422 status' do
          post "/api/v1/questions/#{question.id}/answers", params: { 
            format: :json, access_token: access_token.token,
            answer: attributes_for(:invalid_answer)
          }
          expect(response.status).to eq 422
        end

        it 'does not save answer' do
          expect { post "/api/v1/questions/#{question.id}/answers", params: {
            format: :json, access_token: access_token.token, 
            answer: attributes_for(:invalid_answer)
          }}.to_not change(Answer, :count)
        end
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", params: { 
        format: :json, 
        answer: attributes_for(:answer) 
      }.merge(options)
    end
  end
end
