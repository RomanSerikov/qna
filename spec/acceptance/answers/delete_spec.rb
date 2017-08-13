require 'rails_helper'

feature 'Delete answer', %q{
  In order to cancel my answer
  As a user
  I want to be able to delete my answer
} do

  given(:user)         { create(:user) }
  given(:question)     { create(:question, user: user) }
  given!(:answer)      { create(:answer, question: question, user: user) }
  given(:another_user) { create(:user) }

  scenario 'Authenticated user deletes own answer' do
    sign_in(user)

    visit question_path(question)

    click_on 'Delete my answer'

    expect(page).to have_content 'Your answer succefully deleted.'
    expect(page).to_not have_content 'Answer on test question'
  end

  scenario 'Authenticated user tries to delete another user answer' do
    sign_in(another_user)

    visit question_path(question)

    expect(page).to_not have_content 'Delete my answer'
  end

  scenario 'Non-authenticated user tries to delete answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete my answer'
  end
end
