require 'acceptance_helper'

feature 'Create answer', %q{
  In order to help someone with problem
  As a user
  I want to be able to answer the question
} do

  given(:user)     { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user creates answer with valid parameters', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Answer', with: 'Answer on test question'
    click_on 'Send answer'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Your answer succefully created.'
    within '.answers' do
      expect(page).to have_content 'Answer on test question'
    end
  end

  scenario 'Authenticated user tries to create answer with invalid parameters', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Answer', with: nil
    click_on 'Send answer'

    expect(page).to have_content 'Body can\'t be blank'
  end

  scenario 'Non-authenticated user tries to create answer', js: true do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
