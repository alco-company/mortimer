Rails.application.routes.draw do
  resources :stocked_products

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

  resources :stocks, concerns: [:cloneable, :modalable, :selectable] do
    member do
      get :re_stock
      put :inventory
    end
    resources :stock_locations, concerns: [:cloneable, :modalable] 
    
  end
  
  resources :stock_locations, concerns: [:cloneable, :modalable] 
  resources :products, concerns: [:cloneable, :modalable, :selectable]
  resources :suppliers, concerns: [:cloneable, :modalable, :selectable]
  # resources :events
  resources :tasks, concerns: [:cloneable, :modalable]
  resources :teams, concerns: [:cloneable, :modalable]
  resources :roles, concerns: [:cloneable, :modalable, :selectable]
  resources :services, concerns: [:cloneable, :modalable, :selectable]
  resources :users, concerns: [:cloneable, :modalable]
  resources :participants
  resources :calendars
  resources :accounts, concerns: [:cloneable, :modalable] do
    post "impersonate", to: "accounts#impersonate"
  end


  resources :dashboards, concerns: [:cloneable, :modalable] 
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
