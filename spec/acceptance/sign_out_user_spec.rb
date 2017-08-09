require 'rails_helper'

feature 'User sign out', %q{
  In order to be able to leave my account
  As a user
  I want to be able to sign out
} do

  scenario 'User try to sign out' do
    User.create!(email: 'userout@test.com', password: '12345678')

    visit new_user_session_path
    fill_in 'Email', with: 'userout@test.com'
    fill_in 'Password', with: '123456678'
    click_on 'Log in'

    click_on 'Log out'
    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end
