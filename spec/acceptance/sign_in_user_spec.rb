require 'rails_helper'

feature 'User sign in', %q{
  In order to be able to ask question
  As a user
  I want to be able to sign in
} do

  scenario 'User try to sign in' do
    User.create!(email: 'user@test.com', password: '12345678')

    visit new_user_session_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end
end
