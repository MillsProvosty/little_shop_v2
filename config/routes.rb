Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #visitor paths
  root to: 'welcome#index'

  resources :items, only: [:index, :show]
  resources :merchants, only: [:index]
  resources :users, only: [:create]

  get '/register', to: "users#new", as: :new_user

  get '/login', to: "sessions#new", as: :login
  post '/login', to: "sessions#create"
  get 'logout', to: "sessions#destroy", as: :logout

  resources :carts, only: [:create]
  get '/cart', to: 'carts#show'
  delete '/cart', to: 'carts#destroy'
  delete '/cart/item/:id', to: 'carts#delete_item', as: :cart_delete_item
  post '/cart/item/:id', to: 'carts#add_item', as: :cart_add_item
  patch '/cart/item/:id', to: 'carts#eliminate_item', as: :cart_eliminate_item

  ## RESTRICTED PATHS ##
  # user_paths
  scope :profile, module: :user, as: :user do
    get '/', to: "users#show"
    patch '/', to: "users#update"
    get '/edit', to: "users#edit"
    get '/orders', to: "users#orders"
    post '/orders', to: "users#checkout"
    delete '/order/:id', to: "users#destroy", as: :cancel_order
  end

  # merchant_paths
  scope :dashboard, module: :merchant, as: :merchant do
    get '/', to: "merchants#show", as: :dashboard
    resources :items, only: [:index, :update, :destroy]
    resources :orders, only: [:show]
  end

  # admin_paths
  namespace :admin do
    get '/dashboard', to: 'admin#show', as: :dashboard
    get '/', to: redirect('/404') #until/unless we have an admin index page
    resources :users, only: [:index, :show, :create]
    resources :orders, only: [:update]
  end

  namespace :admin do
    resources :merchants, only: [:show]
    resources :users, only: [:create]
  end

  post "/admin/users/:id", to: 'admin/users#update'
end
