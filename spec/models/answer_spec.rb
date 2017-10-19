require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'commentable'
  it_behaves_like 'attachable'

  it { should belong_to :question }
  it { should have_db_column :question_id }
  it { should belong_to(:user) }
  it { should have_db_column(:user_id) }

  it { should validate_presence_of :body }
  it { should validate_uniqueness_of(:best).scoped_to(:question_id) }

  describe '#mark_best' do
    let(:user)     { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer)   { create(:answer, question: question, user: user) }

    it 'change boolean attribute best to true' do
      answer.mark_best
      expect(answer.best).to be true
    end
  end
end
