require 'acceptance_helper'

feature 'Edit answer', %q{
  In order to fix my mistake
  As an author of answer
  I want to be able to edit my answer
} do

  given(:user)             { create(:user) }
  given(:another_user)     { create(:user) }
  given(:question)         { create(:question, user: user) }
  given(:another_question) { create(:question, user: another_user) }
  given!(:answer)          { create(:answer, question: question, user: user) }
  given!(:another_answer)  { create(:answer, question: another_question, user: another_user) }

  scenario 'Unauthenticated user try to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link Edit answer' do
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'try to edit his answer', js: true do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'try to edit other user answer', js: true do
      visit question_path(another_question)

      within '.answers' do
        expect(page).to_not have_link 'Edit'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end
end
