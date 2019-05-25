Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#index'
  # get '/cart', to: "cart#show"
  resources :items, only: [:index, :show]
  resources :merchants, only: [:index]
  resources :users, only: [:index, :create]

  get '/login', to: "sessions#new", as: :login
  post '/login', to: "sessions#create"
  get 'logout', to: "sessions#destroy", as: :logout

  # user_paths
  get '/register', to: "users#new", as: :new_user
  get '/profile/edit', to: "users#edit", as: :user_edit
  get '/profile', to: "users#show", as: :user_profile
  patch '/profile', to: "users#update", as: :user_update
  get '/profile/orders', to: "users#checkout", as: :profile_orders

  # merchant_paths
  # resources :merchants, only: [:show], as: :merchant_dashboard
  get '/dashboard', to: "merchants#show", as: :merchant_dashboard
  get '/dashboard/orders/:id', to: "order#show", as: :merchant_orders

  # admin_paths
  namespace :admin do
    get '/dashboard', to: 'admin#show'
  end

  resources :carts, only: [:create]
  get '/cart', to: 'carts#show'
  delete '/cart', to: 'carts#destroy'
  delete '/cart/item/:id', to: 'carts#delete_item', as: :cart_delete_item
  post '/cart/item/:id', to: 'carts#add_item', as: :cart_add_item
  patch '/cart/item/:id', to: 'carts#eliminate_item', as: :cart_eliminate_item

end
