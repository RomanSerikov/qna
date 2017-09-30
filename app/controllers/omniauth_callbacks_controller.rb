class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_provider_name, only: [:facebook, :twitter]
  before_action :make_oauth, only: [:facebook, :twitter]

  def facebook
  end

  def twitter
  end

  def register
    User.register_for_oauth(params[:email], params[:provider], params[:uid])
    redirect_to new_user_session_path, notice: 'You have to confirm your email address before continuing.'
  end

  private

  def set_provider_name
    @provider_name = request.env['omniauth.auth'].provider.capitalize
  end

  def make_oauth
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: @provider_name) if is_navigational_format?
    else
      @auth_info = request.env["omniauth.auth"]
      render 'omniauth/add_email'
    end
  end
end
