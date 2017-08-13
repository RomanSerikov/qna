require 'rails_helper'

feature 'User sign out', %q{
  In order to be able to leave my account
  As a user
  I want to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'User try to sign out' do
    sign_in(user)

    visit root_path
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end
