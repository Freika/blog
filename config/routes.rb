Rails.application.routes.draw do
  resources :user_sessions
  resources :users

  get 'login' => 'user_sessions#new', :as => :login
  post 'logout' => 'user_sessions#destroy', :as => :logout

  resources :users

  resources :posts, path: ""

  root 'posts#index'

  get 'bonus/digitalocean' => redirect('https://www.digitalocean.com/?refcode=5dcbfa133a56')

end
