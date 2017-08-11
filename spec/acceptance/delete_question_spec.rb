require 'rails_helper'

feature '', %q{
  In order to fix my mistake
  As a user
  I want to be able to delete my question
} do
  
  scenario 'Authenticated user deletes own question' do
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

    click_on 'Delete my question'
    expect(current_path).to eq questions_path
    expect(page).to have_content 'Your question succefully deleted.'
    expect(page).to_not have_content 'Test question'
  end
end
