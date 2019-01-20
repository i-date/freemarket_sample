class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :check_captcha, only: [:create]

  def index
  end

  def create
    build_resource(sign_up_params)
    resource.save
    profile = Profile.new({ nickname: resource.nickname, user_id: resource.id })
    profile.save(validate: false)
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  private

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :email, :password, :password_confirmation])
  end

  def check_captcha
    self.resource = resource_class.new sign_up_params
    resource.validate
    unless verify_recaptcha(model: resource)
      render :new
    end
  end
end
