Rails.application.routes.draw do
  devise_for :users, skip: :all,
    controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks',
      registrations:      'users/registrations',
      sessions:      'users/sessions'
    }

  get '/', to: redirect('/jp')
  scope '/jp' do
    root to: 'items#index'

    # マイページ
    get 'mypage', to: 'mypage/mypage#index', as: :mypage_top
    get 'logout', to: 'mypage/logout#index', as: :mypage_logout
    namespace :mypage do
      get   'profile',        to: 'profile#edit',          as: :profile
      patch 'profile',        to: 'profile#update',        as: :profile_update
      get   'identification', to: 'identification#edit',   as: :identification
      patch 'identification', to: 'identification#update', as: :identification_update
    end

    # 商品関連ページ
    get  'sell', to: 'items#new',    as: :new_item
    post 'sell', to: 'items#create', as: :create_item
    get  ':id',  to: 'items#show',   as: :show_item

    # TODO:仮のURIを修正
    devise_scope :user do
      # session
      get    'login',                 to: 'users/sessions#new',          as: :new_user_session
      post   'login',                 to: 'users/sessions#create',       as: :user_session
      delete 'logout',                to: 'users/sessions#destroy',      as: :destroy_user_session
      # registration
      get    'signup',                to: 'users/registrations#index',   as: :start_user_registration
      get    'signup/registration',   to: 'users/registrations#new',     as: :new_user_registration
      patch  'users',                 to: 'users/registrations#update',  as: :user_registration
      put    'users',                 to: 'users/registrations#update'
      delete 'users',                 to: 'users/registrations#destroy'
      post   'signup/registration',   to: 'users/registrations#create',  as: :create_user_registration
      # password
      get    'password/reset/start/', to: 'devise/passwords#new',        as: :new_user_password
      get    'password/edit',         to: 'devise/passwords#edit',       as: :edit_user_password
      patch  'users/passwords',       to: 'devise/passwords#update',     as: :user_password
      put    'users/passwords',       to: 'devise/passwords#update'
      post   'users/passwords',       to: 'devise/passwords#create'
      # omniauth_callback
      match  'signup/facebook/auth',     to: 'users/omniauth_callbacks#passthru', via: [:get, :post], as: :user_facebook_omniauth_authorize
      match  'signup/facebook/callback', to: 'users/omniauth_callbacks#callback', via: [:get, :post]
      get    'signup/facebook',          to: 'users/omniauth_callbacks#new',                          as: :new_user_facebook_omniauth_registration
      post   'signup/facebook',          to: 'users/omniauth_callbacks#create',                       as: :create_user_facebook_omniauth_registration
      match  'signup/google/auth',       to: 'users/omniauth_callbacks#passthru', via: [:get, :post], as: :user_google_oauth2_omniauth_authorize
      match  'signup/google/callback',   to: 'users/omniauth_callbacks#callback', via: [:get, :post]
      get    'signup/google',            to: 'users/omniauth_callbacks#new',                          as: :new_user_google_omniauth_registration
      post   'signup/google',            to: 'users/omniauth_callbacks#create',                       as: :create_user_google_omniauth_registration
    end
  end
end
