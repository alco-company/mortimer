Rails.application.routes.draw do

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  
  resources :dashboards
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get '/check.txt', to: proc {[200, {}, ['check_ok']]}

  root to: "dashboards#landing"
end
