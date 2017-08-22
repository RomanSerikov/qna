require 'acceptance_helper'

feature 'Edit question', %q{
  In order to fix my mistake
  As a author of question
  I want to be able to edit my question
} do

  given(:user)             { create(:user) }
  given(:another_user)     { create(:user) }
  given(:question)         { create(:question, user: user) }
  given(:another_question) { create(:question, user: another_user) }

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)

    expect(page).to_not have_link "Edit my question"
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link Edit question' do
      expect(page).to have_link "Edit my question"
    end

    scenario 'try to edit his answer', js: true do
      click_on 'Edit my question'

      within '.question' do
        fill_in 'Question title', with: 'edited question title'
        fill_in 'Question body', with: 'edited question body'
        click_on 'Save question'

        expect(page).to have_content 'edited question title'
        expect(page).to have_content 'edited question body'
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'try to edit other user question' do
      visit question_path(another_question)

      within '.question' do
        expect(page).to_not have_content 'Edit my question'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end
end
