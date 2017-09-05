require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'votable'

  it { should belong_to :question }
  it { should have_db_column :question_id }
  it { should belong_to(:user) }
  it { should have_db_column(:user_id) }

  it { should have_many(:attachments).dependent(:destroy) }

  it { should validate_presence_of :body }
  it { should validate_uniqueness_of(:best).scoped_to(:question_id) }

  it { should accept_nested_attributes_for :attachments }

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
