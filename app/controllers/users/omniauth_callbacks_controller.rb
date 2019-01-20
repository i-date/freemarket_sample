class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :check_captcha, only: [:create]

  def new
    @user = User.new
    @sns_user = SnsUser.temporary_params(session["devise.omniauth_data"])
  end

  def create
    @sns_user = SnsUser.new(sns_user_params)
    @user = User.new(@sns_user.user_params)
    if @user.save
      SnsCredential.create(@sns_user.sns_params.merge(user_id: @user.id))
      sign_in_and_custom_redirect @user, event: :authentication
    else
      render :new
    end
  end

  def callback
    callback_for(request.env["omniauth.auth"])
  end

  private

  def callback_for(response)
    @user = User.from_omniauth(response)
    if @user.present?
      sign_in_and_custom_redirect @user, event: :authentication
    else
      session["devise.omniauth_data"] = response
      provider_path = response["provider"].to_s.eql?("facebook") ? new_user_facebook_omniauth_registration_path : new_user_google_omniauth_registration_path
      redirect_to provider_path
    end
  end

  def check_captcha
    @sns_user = SnsUser.new(sns_user_params)
    @user = User.new(@sns_user.user_params)
    @user.validate
    unless verify_recaptcha(model: @user)
      render :new
    end
  end

  def sign_in_and_custom_redirect(resource_or_scope, *args)
    options = args.extract_options!
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    resource = args.last || resource_or_scope
    sign_in(scope, resource, options)
    user = User.find(resource.id)
    if user.profile.blank?
      profile = Profile.new({ nickname: user.nickname, user_id: user.id })
      profile.save(validate: false)
    end
    redirect_to after_sign_in_path_for(resource)
  end

  def failure
    redirect_to root_path
  end

  def sns_user_params
    params.require(:sns_user).permit(:nickname, :email, :password, :password_confirmation, :uid, :provider)
  end
end
