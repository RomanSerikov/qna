require 'acceptance_helper'

feature 'Choose best answer', %q{
  In order to mark the answer, that solved my problem
  As an author of question
  I want to be able to choose the best answer
} do

  given(:user)        { create(:user) }
  given(:author)      { create(:user) }
  given(:question)    { create(:question, user: author) }
  given!(:answer_1)   { create(:answer, question: question, user: author) }
  given!(:answer_2)   { create(:answer, question: question, user: author, body: 'i am best') }

  describe "Not a question author can't choose the best answer" do
    before { visit question_path(question) }

    scenario 'as a unauthenticated user' do
      expect(page).to_not have_link 'Mark as best'
    end

    scenario 'as a authenticated user' do
      sign_in(user)
      expect(page).to_not have_link 'Mark as best'
    end
  end

  describe 'Question author' do
    before do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'see the links to choose the best answer' do
      expect(page).to have_link 'Mark as best', count: 2
    end

    scenario 'try to choose the best answer', js: true do
      within "#answer-#{question.answers.last.id}" do
        click_on 'Mark as best'
      end

      within '.best-answer' do
        expect(page).to have_content answer_2.body
        expect(page).to_not have_content answer_1.body
      end
    end

    scenario 'try to choose another best answer, when one already chosen', js: true do
      within "#answer-2" do
        click_on 'Mark as best'
      end

      within "#answer-1" do
        click_on 'Mark as best'
      end

      within '.best-answer' do
        expect(page).to have_content answer_1.body
        expect(page).to_not have_content answer_2.body
      end
    end
  end
end
