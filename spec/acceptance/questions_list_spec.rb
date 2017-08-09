require 'rails_helper'

feature 'Display questions list', %q{
  In order to see all questions
  As a user
  I want to see questions list
} do

  scenario 'User sees questions list' do
    create_list(:question, 3)
    
    visit questions_path

    expect(page).to have_content('MyString', count: 3)
    expect(page).to have_content('MyText', count: 3)
  end
end
