require 'rails_helper'

feature 'Create answer', %q{
  In order to help someone with problem
  As a user
  I want to be able to answer the question
} do

  scenario 'User creates answer' do
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
end
