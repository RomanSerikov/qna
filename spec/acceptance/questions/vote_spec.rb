require 'acceptance_helper'

feature 'Vote for question', %q{
  In order to rate question
  As an authenticated user
  I want to be able to vote for question
} do

  given(:user)     { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Non-authenticated user tries to vote for question' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_content '+'
    end
  end
  scenario 'Authenticated user try to vote for question', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      click_on '+'
      expect(page).to have_content 'Question rating: 1'
    end
  end
end
