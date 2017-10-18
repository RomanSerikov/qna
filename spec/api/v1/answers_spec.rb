require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    let(:question) { create(:question) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", params: { 
          format: :json, access_token: '1234'
        }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers)     { create_list(:answer, 2, question: question) }
      let!(:answer)      { answers.last }

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
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    let(:answer) { create(:answer) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comment)     { create(:answer_comment, commentable: answer) }
      let!(:attachment)  { create(:attachment, attachable: answer) }

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

      context 'attachments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("answer/attachments")
        end

        it 'contains attachment url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("answer/attachments/0/url")
        end
      end

      context 'comments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("answer/comments")
        end

        %w(id body commentable_type commentable_id user_id created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'POST /create' do
    let(:question) { create(:question) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        post "/api/v1/questions/#{question.id}/answers", params: { 
          format: :json, answer: attributes_for(:answer) 
        }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        post "/api/v1/questions/#{question.id}/answers", params: { 
          format: :json, access_token: '1234', answer: attributes_for(:answer)
        }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      it 'returns 210 status' do
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
  end
end
