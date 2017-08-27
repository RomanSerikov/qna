require 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As a question's author
  I want to be able to attach files
} do

  given(:user) { create(:user) }

  background do
    sing_in(user)
    visit new_question_path
  end

  scenario 'User adds file when he is asking the question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'test test test'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_content 'spec_helper.rb'
  end
end
