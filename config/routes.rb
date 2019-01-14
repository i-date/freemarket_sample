Rails.application.routes.draw do
  devise_for :users, skip: :all,
    controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks',
      registrations:      'users/registrations'
    }

  get '/', to: redirect('/jp')
  scope '/jp' do
    root to: 'items#index'

    namespace :mypage do
      get '', to: 'mypage#index', as: :top
    end

    # TODO:仮のURIを修正
    devise_scope :user do
      # session
      get    'login',                 to: 'devise/sessions#new',         as: :new_user_session
      post   'login',                 to: 'devise/sessions#create',      as: :user_session
      delete 'logout',                to: 'devise/sessions#destroy',     as: :destroy_user_session
      # registration
      get    'signup',                to: 'users/registrations#index',   as: :start_user_registration
      get    'signup/registration',   to: 'devise/registrations#new',    as: :new_user_registration
      patch  'users',                 to: 'devise/registrations#update', as: :user_registration
      put    'users',                 to: 'devise/registrations#update'
      delete 'users',                 to: 'devise/registrations#destroy'
      post   'signup/registration',   to: 'devise/registrations#create', as: :create_user_registration
      # password
      get    'password/reset/start/', to: 'devise/passwords#new',        as: :new_user_password
      get    'password/edit',         to: 'devise/passwords#edit',       as: :edit_user_password
      patch  'users/passwords',       to: 'devise/passwords#update',     as: :user_password
      put    'users/passwords',       to: 'devise/passwords#update'
      post   'users/passwords',       to: 'devise/passwords#create'
      # omniauth_callback
      match  'signup/facebook/auth',     to: 'users/omniauth_callbacks#passthru',          via: [:get, :post], as: :user_facebook_omniauth_authorize
      match  'signup/facebook/callback', to: 'users/omniauth_callbacks#facebook_callback', via: [:get, :post], as: :user_facebook_omniauth_callback
      get    'signup/facebook',          to: 'users/omniauth_callbacks#facebook',                              as: :new_user_facebook_omniauth_registration
      post   'signup/facebook',          to: 'users/omniauth_callbacks#create',                                as: :create_user_facebook_omniauth_registration
      match  'signup/google/auth',       to: 'users/omniauth_callbacks#passthru',          via: [:get, :post], as: :user_google_oauth2_omniauth_authorize
      match  'signup/google/callback',   to: 'users/omniauth_callbacks#google_callback',   via: [:get, :post], as: :user_google_omniauth_callback
      get    'signup/google',            to: 'users/omniauth_callbacks#google',                                as: :new_user_google_omniauth_registration
      post   'signup/google',            to: 'users/omniauth_callbacks#create',                                as: :create_user_google_omniauth_registration
    end
  end
end
