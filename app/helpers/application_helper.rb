module ApplicationHelper

  def select_oauth_path(provider)
    case provider
    when 'facebook'
      create_user_facebook_omniauth_registration_path
    when 'google_oauth2'
      create_user_google_omniauth_registration_path
    end
  end
end
