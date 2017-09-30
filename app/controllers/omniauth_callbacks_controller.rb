class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    end
  end

  def twitter
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
    else
      @request_info = request.env["omniauth.auth"]
      render 'omniauth/add_email'
    end
  end

  def register
    User.register_for_oauth(params[:email], params[:provider], params[:uid])
    redirect_to new_user_session_path, notice: 'You have to confirm your email address before continuing.'
  end
end
