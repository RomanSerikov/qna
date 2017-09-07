require 'acceptance_helper'

feature 'Vote for answer', %q{
  In order to rate answer
  As an authenticated user
  I want to be able to vote for answer
} do

  given(:user)     { create(:user) }
  given(:author)   { create(:user) }
  given(:question) { create(:question) }
  given!(:answer)  { create(:answer, question: question, user: author) }

  scenario 'Non-authenticated user tries to vote for answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_content '+'
    end
  end

  context 'Authenticated user' do
    scenario 'try to vote for his own answer', js: true do
      sign_in(author)
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_content '+'
      end
    end

    scenario 'try to vote for another user answer', js: true do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        click_on '+'
        expect(page).to have_content 'Answer rating: 1'
      end
    end

    scenario 'try to vote for another user answer twice', js: true do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        click_on '+'
        wait_for_ajax
        click_on '+'
        wait_for_ajax
        expect(page).to have_content 'Answer rating: 0'
      end
    end
  end
end
