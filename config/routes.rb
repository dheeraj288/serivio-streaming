Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root 'dashboard#index'

  get 'signup', to: 'registrations#new'
  post 'signup', to: 'registrations#create'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get  '/verify_otp', to: 'otp#new', as: 'verify_otp'
  post '/verify_otp', to: 'otp#create'
  get  '/resend_otp', to: 'otp#resend', as: 'resend_otp'

  get '/auth/:provider/callback', to: 'registrations#google_oauth'
end
