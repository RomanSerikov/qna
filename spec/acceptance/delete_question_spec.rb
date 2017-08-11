require 'rails_helper'

feature 'Delete question', %q{
  In order to fix my mistake
  As a user
  I want to be able to delete my question
} do
  
  given(:user)     { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user deletes own question' do
    sign_in(user)

    visit question_path(question)

    click_on 'Delete my question'

    expect(current_path).to eq questions_path
    expect(page).to have_content 'Your question succefully deleted.'
    expect(page).to_not have_content 'Test question'
  end
end
