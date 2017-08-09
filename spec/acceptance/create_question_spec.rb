require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As a user
  I want to be able to ask question
} do

  scenario 'user creates question' do
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'test test test'
    click_on 'Create'

    expect(page).to have_content 'Your question succefully created.'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'test test test'
  end
end
