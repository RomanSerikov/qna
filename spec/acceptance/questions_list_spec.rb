require 'rails_helper'

feature 'Display questions list', %q{
  In order to see all questions
  As a user
  I want to see questions list
} do

  given(:user)       { create(:user) }
  given!(:questions) { create_list(:question, 3, user: user) }

  scenario 'User sees questions list' do
    visit questions_path

    expect(page).to have_content('MyQuestionTitle', count: 3)
    expect(page).to have_content('MyQuestionText', count: 3)
  end
end
