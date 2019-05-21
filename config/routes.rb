Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#index'
  resources :items, only: [:index, :show]
  resources :merchants, only: [:index]
  resources :users, only: [:new, :index, :create]


  get '/user/profile/:id', to: 'users#show', as: :user_profile

end
