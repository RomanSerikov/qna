require 'acceptance_helper'

feature 'User sign in with twitter account', %q{
  In order to be able to ask question
  As a user
  I want to be able to sign in using twitter
} do

  background do
    clear_emails
    visit new_user_session_path
  end

  scenario 'User try to sign in' do
    mock_twitter_auth_hash
    click_on 'Sign in with Twitter'
    fill_in 'Email', with: 'test@example.com'
    click_on 'Send'

    open_email('test@example.com')
    current_email.click_link 'Confirm my account'

    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Successfully authenticated from Twitter account.'
    expect(current_path).to eq root_path
  end

  scenario 'User fails twitter authentication' do
    mock_invalid_twitter_auth_hash
    click_on 'Sign in with Twitter'

    expect(page).to have_content "Could not authenticate you from Twitter because \"Invalid credentials\"."
  end
end
