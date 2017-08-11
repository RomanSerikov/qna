require 'rails_helper'

feature '', %q{
  In order to cancel my answer
  As a user
  I want to be able to delete my answer
} do

  scenario 'Authenticated user deletes own answer' do
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

    click_on 'Delete my answer'
    expect(page).to have_content 'Your answer succefully deleted.'
    expect(page).to_not have_content 'Answer on test question'
  end
end
