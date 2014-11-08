Rails.application.routes.draw do
  devise_for :users
  get 'tags/:tag', to: 'posts#index', as: :tag
  resources :posts, path: ''
  root 'posts#index'
  get 'bonus/digitalocean' => redirect('https://www.digitalocean.com/?refcode=5dcbfa133a56')

end
