class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    @user = User.new
    @sns_user = SnsUser.temporary_params(session["devise.facebook_data"])
  end

  def google
    @user = User.new
    @sns_user = SnsUser.temporary_params(session["devise.google_data"])
  end

  def create
    @sns_user = SnsUser.new(sns_user_params)
    @user = User.new(@sns_user.user_params)
    if @user.save
      SnsCredential.create(@sns_user.sns_params.merge(user_id: @user.id))
      sign_in_and_redirect @user, event: :authentication
    else
      if @sns_user.provider.eql?('facebook')
        render :facebook
      else
        render :google
      end
    end
  end

  # callback for facebook
  def facebook_callback
    callback_for(:facebook)
  end

  # callback for google
  def google_callback
    callback_for(:google)
  end

  private

  def callback_for(provider)
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.present?
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.#{provider}_data"] = request.env["omniauth.auth"]
      provider_path = provider.to_s.eql?("google") ? new_user_google_omniauth_registration_path : new_user_facebook_omniauth_registration
      redirect_to provider_path
    end
  end

  def failure
    redirect_to root_path
  end

  def sns_user_params
    params.require(:sns_user).permit(:nickname, :email, :password, :password_confirmation, :uid, :provider)
  end
end
