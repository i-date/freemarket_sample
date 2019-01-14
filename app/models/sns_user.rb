class SnsUser
  include ActiveModel::Model

  attr_accessor  :nickname, :email, :password, :password_confirmation, :uid, :provider

  def initialize(attributes={})
    super
  end

  def user_params
    {
      nickname:              self.nickname,
      email:                 self.email,
      password:              self.password,
      password_confirmation: self.password_confirmation
    }
  end

  def sns_params
    {
      uid:      self.uid,
      provider: self.provider
    }
  end

  def self.temporary_params(auth)
    password = Devise.friendly_token[0,20]

    sns_user = SnsUser.new(
      email:                 auth["info"]["email"],
      password:              password,
      password_confirmation: password,
      uid:                   auth["uid"],
      provider:              auth["provider"]
    )
  end
end
