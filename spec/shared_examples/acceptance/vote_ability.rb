require 'rails_helper'

shared_examples 'Vote ability' do
  let(:user)   { create(:user) }
  let(:author) { create(:user) }

  scenario 'Non-authenticated user tries to vote' do
    visit question_path(question)

    within container do
      expect(page).to_not have_content '+'
    end
  end

  context 'Authenticated user' do
    scenario 'try to vote for his own object', js: true do
      sign_in(author)
      visit question_path(question)

      within container do
        expect(page).to_not have_content '+'
      end
    end

    scenario 'try to vote for another user object positively', js: true do
      sign_in(user)
      visit question_path(question)

      within container do
        click_on '+'
        expect(page).to have_content "#{obj} rating: 1"
      end
    end

    scenario 'try to vote for another user object negatively', js: true do
      sign_in(user)
      visit question_path(question)

      within container do
        click_on '-'
        expect(page).to have_content "#{obj} rating: -1"
      end
    end

    scenario 'try to vote for another user object twice', js: true do
      sign_in(user)
      visit question_path(question)

      within container do
        click_on '+'
        wait_for_ajax
        click_on '+'
        wait_for_ajax
        expect(page).to have_content "#{obj} rating: 0"
      end
    end
  end
end
