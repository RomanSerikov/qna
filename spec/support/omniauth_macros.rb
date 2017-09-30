module OmniauthMacros
  def mock_facebook_auth_hash
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      'provider' => 'facebook',
      'uid' => '123456',
      'info' => {
        'email' => 'facebook@user.com',
        'name' => 'Albert Einstein',
        'first_name' => 'Albert',
        'last_name' => 'Einstein'
      }
    })
  end

  def mock_invalid_facebook_auth_hash
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
  end

  def mock_twitter_auth_hash
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      'provider' => 'twitter',
      'uid' => '1234567',
      'info' => {
        'name' => 'Albert Einstein',
        'first_name' => 'Albert',
        'last_name' => 'Einstein'
      }
    })
  end

  def mock_invalid_twitter_auth_hash
    OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
  end
end
