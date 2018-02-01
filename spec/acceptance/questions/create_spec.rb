require 'acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community
  As a user
  I want to be able to ask question
} do

  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
    end

    scenario 'creates question with valid parameters', js: true do
      click_on 'Ask question'
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'test test test'
      click_on 'Create'

      expect(page).to have_content 'Question was successfully created'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'test test test'
    end

    scenario 'tries to create question with invalid parameters', js: true do
      click_on 'Ask question'
      fill_in 'Title', with: nil
      fill_in 'Body', with: nil
      click_on 'Create'

      expect(page).to have_content 'Body can\'t be blank'
      expect(page).to have_content 'Title can\'t be blank'
    end
  end

  describe 'Multiple sessions' do
    scenario "question appears on another user' page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'test test test'
        click_on 'Create'

        expect(page).to have_content 'Question was successfully created'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'test test test'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
