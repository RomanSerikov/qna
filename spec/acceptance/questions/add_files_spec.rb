require 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As a question's author
  I want to be able to attach files
} do

  given(:user)       { create(:user) }
  given(:upload_dir) { "/uploads/attachment/file" }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file when he is asking the question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'test test test'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: "#{upload_dir}/1/spec_helper.rb"
  end

  scenario 'User adds two files when he is asking the question', js: true do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'test test test'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

    click_on 'add file'

    within all('.nested-fields').last do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: "#{upload_dir}/2/spec_helper.rb"
    expect(page).to have_link 'rails_helper.rb', href: "#{upload_dir}/3/rails_helper.rb"
  end
end
