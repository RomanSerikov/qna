require 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As a answer's author
  I want to be able to attach files
} do

  given(:user)       { create(:user) }
  given(:question)   { create(:question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file to answer', js: true do
    fill_in 'Answer', with: 'Answer on test question'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb" 
    click_on 'Send answer'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'User adds two files to answer', js: true do
    fill_in 'Answer', with: 'Answer on test question'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

    click_on 'add file'

    within all('.nested-fields').last do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Send answer'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb'
    end
  end
end
