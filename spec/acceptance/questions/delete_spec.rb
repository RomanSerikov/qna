require 'rails_helper'

feature 'Delete question', %q{
  In order to fix my mistake
  As a user
  I want to be able to delete my question
} do
  
  given(:user)         { create(:user) }
  given(:question)     { create(:question, user: user) }
  given(:another_user) { create(:user) }

  scenario 'Authenticated user deletes own question' do
    sign_in(user)

    visit question_path(question)
    click_on 'Delete my question'

    expect(current_path).to eq questions_path
    expect(page).to have_content 'Your question succefully deleted.'
    expect(page).to_not have_content question.title
  end

  scenario 'Authenticated user tries to delete another user question' do
    sign_in(another_user)

    visit question_path(question)

    expect(page).to_not have_content 'Delete my question'
  end

  scenario 'Non-authenticated user tries to delete question' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete my question'
  end 
end
