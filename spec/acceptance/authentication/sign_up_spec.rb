require 'acceptance_helper'

feature 'User sign up', %q{
  In order to create account
  As a user
  I want to sign up
} do

  scenario 'User try to sign up with valid data' do
    visit new_user_registration_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
    expect(current_path).to eq root_path
  end

  scenario 'User try to sign up with invalid data' do
    visit new_user_registration_path
    fill_in 'Email', with: 'invalid@test.com'
    fill_in 'Password', with: nil
    fill_in 'Password confirmation', with: nil
    click_on 'Sign up'

    expect(page).to have_content 'Password can\'t be blank'
  end
end
