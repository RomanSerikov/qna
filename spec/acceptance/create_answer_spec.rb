require 'rails_helper'

feature 'Create answer', %q{
  In order to help someone with problem
  As a user
  I want to be able to answer the question
} do

  scenario 'Authenticated user creates answer with valid parameters' do
    User.create!(email: 'user@test.com', password: '12345678')

    visit new_user_session_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'test test test'
    click_on 'Create'

    fill_in 'Answer', with: 'Answer on test question'
    click_on 'Send answer'

    expect(page).to have_content 'Your answer succefully created.'
    expect(page).to have_content 'Answer on test question'
  end

  scenario 'Authenticated user tries to create answer with invalid parameters' do
    User.create!(email: 'user@test.com', password: '12345678')

    visit new_user_session_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'test test test'
    click_on 'Create'

    fill_in 'Answer', with: nil
    click_on 'Send answer'

    expect(page).to have_content 'Body can\'t be blank'
  end

  scenario 'Non-authenticated user tries to create answer' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
