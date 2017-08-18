require 'acceptance_helper'

feature 'User sign in', %q{
  In order to be able to ask question
  As a user
  I want to be able to sign in
} do

  given(:user) { create(:user) }

  scenario 'User try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Unregistered user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: 'wrongpass'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end
