require 'acceptance_helper'

feature 'Delete files in answer', %q{
  In order to fix my mistake
  As an author of answer
  I want to be able to delete files in my answer
} do

  given(:user)             { create(:user) }
  given(:another_user)     { create(:user) }
  given(:question)         { create(:question, user: user) }
  given(:another_question) { create(:question, user: another_user) }
  given!(:answer)          { create(:answer, question: question, user: user) }
  given!(:another_answer)  { create(:answer, question: another_question, user: another_user) }
  given!(:attachment)      { create(:attachment, attachable: answer) }

  scenario 'Unauthenticated user try to delete files in answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'try to delete file in his answer', js: true do
      within '.answers' do
        click_on 'Edit'
        click_on 'remove file'
        click_on 'Save'

        expect(page).to_not have_link attachment.file.identifier
      end
    end

    scenario 'try to delete file in other user answer' do
      visit question_path(another_question)

      within '.answers' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
