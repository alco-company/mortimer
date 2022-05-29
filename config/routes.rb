Rails.application.routes.draw do

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  
  concern :modalable do
    collection do
      get 'modal'
    end
  end
  
  concern :selectable do
    collection do
      get 'lookup'
      post 'selected'
    end
  end
  
  concern :cloneable do
    member do
      get 'clonez'
    end
  end
  
  concern :exportable do
    collection do 
      get "export_selection"
      get "export"
    end
  end

  resources :roles
  resources :services
  resources :users
  resources :participants
  resources :calendars
  resources :accounts, concerns: [:cloneable, :modalable] do
    post "impersonate", to: "accounts#impersonate"
  end


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
