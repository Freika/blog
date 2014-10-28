Rails.application.routes.draw do

  resources :posts, path: ""

  root 'posts#index'

  get 'bonus/digitalocean' => redirect('https://www.digitalocean.com/?refcode=5dcbfa133a56')

end
