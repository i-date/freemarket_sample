class Users::SessionsController < Devise::SessionsController
  before_action :check_captcha, only: [:create]

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
