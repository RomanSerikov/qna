require 'rails_helper'

feature 'view question and answers', %q{
  In order to solve my problem
  As a user
  I want to be able to view question and answers on it
} do

  scenario 'user view question and answers' do
    question = create(:question)
    create_list(:answer, 3, question: question)

    visit questions_path
    click_on 'MyQuestionTitle'

    expect(page).to have_content 'MyQuestionTitle'
    expect(page).to have_content 'MyQuestionText'
    expect(page).to have_content('MyAnswerText', count: 3)
  end
end
