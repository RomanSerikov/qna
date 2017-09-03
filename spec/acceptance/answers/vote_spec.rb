require 'acceptance_helper'

feature 'Vote for answer', %q{
  In order to rate answer
  As an authenticated user
  I want to be able to vote for answer
} do

  given(:user)     { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer)  { create(:answer, question: question, user: user) }

  scenario 'Non-authenticated user tries to vote for answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_content '+'
    end
  end
  scenario 'Authenticated user try to vote for answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      click_on '+'
      expect(page).to have_content 'Answer rating: 1'
    end
  end
end
