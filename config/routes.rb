Rails.application.routes.draw do
  get 'feeds/rss'

  devise_for :users
  get 'tags/:tag', to: 'posts#index', as: :tag
  resources :posts, path: ''
  root 'posts#index'
  get 'bonus/digitalocean' => redirect('https://www.digitalocean.com/?refcode=5dcbfa133a56')
  get 'feeds/rss', controller: 'feeds', action: 'rss', format: 'rss', as: :feed

end
