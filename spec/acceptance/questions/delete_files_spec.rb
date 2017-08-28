require 'acceptance_helper'

feature 'Delete files in question', %q{
  In order to fix my mistake
  As a author of question
  I want to be able to delete files in my question
} do

  given(:user)             { create(:user) }
  given(:another_user)     { create(:user) }
  given(:question)         { create(:question, user: user) }
  given(:another_question) { create(:question, user: another_user) }
  given!(:attachment)      { create(:attachment, attachable: question) }

  scenario 'Unauthenticated user try to delete files in question' do
    visit question_path(question)

    expect(page).to_not have_link "Edit my question"
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'try to delete file in his question', js: true do
      click_on 'Edit my question'

      within '.question' do
        click_on 'remove file'
        click_on 'Save question'

        expect(page).to_not have_link attachment.file.identifier
      end
    end

    scenario 'try to delete file in other user question' do
      visit question_path(another_question)

      within '.question' do
        expect(page).to_not have_content 'Edit my question'
      end
    end
  end
end
