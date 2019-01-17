class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :check_captcha, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

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
    if resource.errors.details[:email][0][:error].to_s == "taken"
      resource.errors[:email].pop
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
