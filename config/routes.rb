Rails.application.routes.draw do
  devise_for :users, skip: :all

  scope '/jp' do
    root to: 'items#index'

    # TODO:仮のURIを修正
    devise_scope :user do
      # session
      get    'login',                to: 'devise/sessions#new',         as: :new_user_session
      post   'login',                to: 'devise/sessions#create',      as: :user_session
      delete 'logout',               to: 'devise/sessions#destroy',     as: :destroy_user_session
      # registration
      get    'signup/registration',  to: 'devise/registrations#new',    as: :new_user_registration
      patch  'users',                to: 'devise/registrations#update', as: :user_registration
      put    'users',                to: 'devise/registrations#update'
      delete 'users',                to: 'devise/registrations#destroy'
      post   'signup/registration',  to: 'devise/registrations#create', as: :create_user_registration
      # password
      get   'password/reset/start/', to: 'devise/passwords#new',        as: :new_user_password
      get   'password/edit',         to: 'devise/passwords#edit',       as: :edit_user_password
      patch 'users/passwords',       to: 'devise/passwords#update',     as: :user_password
      put   'users/passwords',       to: 'devise/passwords#update'
      post  'users/passwords',       to: 'devise/passwords#create'
    end
  end
end
