require 'acceptance_helper'

feature 'User sign in with facebook account', %q{
  In order to be able to ask question
  As a user
  I want to be able to sign in using facebook
} do

  background do
    visit new_user_session_path
  end

  scenario 'User try to sign in' do
    mock_facebook_auth_hash
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from Facebook account'
    expect(current_path).to eq root_path
  end

  scenario 'User fails facebook authentication' do
    mock_invalid_facebook_auth_hash
    click_on 'Sign in with Facebook'

    expect(page).to have_content "Could not authenticate you from Facebook because \"Invalid credentials\"."
  end
end
