require 'acceptance_helper'

feature 'Create answer', %q{
  In order to help someone with problem
  As a user
  I want to be able to answer the question
} do

  given(:user)     { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates answer with valid parameters', js: true do
      fill_in 'Answer', with: 'Answer on test question'
      click_on 'Send answer'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Answer was successfully created.'
      within '.answers' do
        expect(page).to have_content 'Answer on test question'
      end
    end

    scenario 'tries to create answer with invalid parameters', js: true do
      fill_in 'Answer', with: nil
      click_on 'Send answer'

      expect(page).to have_content 'Body can\'t be blank'
    end
  end

  describe 'Multiple Sessions' do
    scenario "answer appears on another user' page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Answer', with: 'Answer on test question'
        click_on 'Send answer'

        expect(current_path).to eq question_path(question)
        expect(page).to have_content 'Answer was successfully created.'
        within '.answers' do
          expect(page).to have_content 'Answer on test question'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'Answer on test question'
        end
      end
    end
  end

  scenario 'Non-authenticated user tries to create answer', js: true do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
