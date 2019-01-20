class Users::SessionsController < Devise::SessionsController
  before_action :check_captcha, only: [:create]

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    user = User.find(resource.id)
    if user.profile.blank?
      profile = Profile.new({ nickname: user.nickname, user_id: user.id })
      profile.save(validate: false)
    end
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  private

  def check_captcha
    self.resource = resource_class.new sign_in_params
    resource.validate
    remove_unique_validation(resource)
    unless verify_recaptcha(model: resource)
      render :new
    end
  end

  def remove_unique_validation(resource)
    if resource.errors.details[:email].present? && resource.errors.details[:email][0][:error].to_s == "taken"
      resource.errors[:email].pop
    end
  end
end
