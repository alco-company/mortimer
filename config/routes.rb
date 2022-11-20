Rails.application.routes.draw do
  
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  
  # concerns ----
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
  
  # POS ----
  
  scope module: :pos, path: 'pos', as: 'pos' do 
    resources :employees do 
      member do
        get :calendar
        post :punch
      end
      resources :pupil_transactions
    end
    resources :stocks do
      member do
        get :pallets
        get :heartbeat
      end
      resources :stock_item_transactions
      resources :stock_locations
    end
  end
  
  
  # resources ----
  resources :profiles
  resources :time_zones, concerns: [:selectable ]
  resources :system_parameters, concerns: [:cloneable, :modalable, :selectable]

  resources :punch_clocks
  resources :asset_workday_sums
  resources :work_schedules, concerns: [:cloneable, :modalable, :selectable]
  resources :locations, concerns: [:cloneable, :modalable, :selectable] do
    resources :calendars
  end


  resources :products, concerns: [:cloneable, :modalable, :selectable] do
    resources :stock_locations
    resources :stock_items
    resources :stock_item_transactions
    resources :stocked_products, concerns: :modalable
  end
    
  resources :stock_items, concerns:  [:cloneable, :modalable, :exportable] do
    resources :stock_item_transactions
  end
  
  resources :stocked_products, concerns: [:cloneable, :modalable] do
    resources :stock_items, concerns: [:cloneable, :modalable] 
    resources :stock_item_transactions, concerns: [:cloneable, :modalable]
  end
  
  resources :stocks, concerns: [:cloneable, :modalable, :selectable] do
    member do
      get :re_stock
      put :inventory
    end
    
    resources :stock_locations, concerns: [:cloneable, :modalable] 
    
    resources :stocked_products, concerns: :modalable
    resources :stock_locations, concerns: [:cloneable, :modalable] do
      resources :stock_item_transactions, concerns: [:cloneable, :modalable] 
      resources :stock_items, concerns: :modalable do
        resources :stock_item_transactions
      end
    end
    
    resources :stock_items
    
    resources :stock_item_transactions, concerns: [:cloneable, :modalable] 
    
  end
  
  resources :stock_locations, concerns: [:cloneable, :modalable] do
    resources :stock_item_transactions, concerns: [:cloneable, :modalable] 
    resources :stock_items, concerns: :modalable do
      resources :stock_item_transactions
    end
  end
  
  
  resources :suppliers, concerns: [:cloneable, :modalable, :selectable] do
    resources :products
  end
  
  # resources :events
  resources :employees, concerns: [:cloneable, :modalable, :exportable] do
    resources :asset_work_transactions, concerns: [:cloneable, :modalable, :exportable]
    resources :calendars
    resources :tasks, concerns: [:cloneable, :modalable]
    resources :pupils, concerns: [:cloneable, :modalable] do
      resources :pupil_transactions
    end
  end

  resources :asset_work_transactions, concerns: [:cloneable, :modalable, :exportable]

  
  resources :pupils, concerns: [:cloneable, :modalable] do
    resources :pupil_transactions
  end
  resources :stock_item_transactions, concerns: [:cloneable, :modalable]
  resources :stocked_products
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
  
  # Add route for OmniAuth callback
  get 'auth/:provider/callback', to: 'auth#callback'
  
  resources :confirmations, only: [:create, :edit, :new], param: :confirmation_token
  resources :passwords, only: [:create, :edit, :new, :update], param: :password_reset_token
  
  # this next endpoint is meant for dokku to use upon start
  # to verify that the service did infact start up as expected
  get '/check.txt', to: proc {[200, {}, ['check_ok']]}
  
  
  root to: "dashboards#landing"
  
end
