Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#index'
  resources :items, only: [:index, :show]
  resources :merchants, only: [:index]

  get '/login', to: "sessions#new", as: :login
  post '/login', to: "sessions#create"
  # user_paths
  get '/profile/:id', to: "users#show", as: :user_profile

  # merchant_paths
  resources :merchants, only: [:show], as: :merchant_dashboard
end