Rails.application.routes.draw do
  resources :services
  resources :users
  resources :participants
  resources :calendars
  resources :accounts

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  
  resources :dashboards
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html


  # user sign-in, -out, and -up
  post "sign_up", to: "users#create"
  get "sign_up", to: "users#sign_up"
  
  post "login", to: "sessions#create"
  post "logout", to: "sessions#destroy"
  get "login", to: "sessions#new"
  
  resources :confirmations, only: [:create, :edit, :new], param: :confirmation_token
  resources :passwords, only: [:create, :edit, :new, :update], param: :password_reset_token


  get '/check.txt', to: proc {[200, {}, ['check_ok']]}

  root to: "dashboards#landing"
  
end
