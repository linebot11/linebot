Rails.application.routes.draw do

  root  'posts#index'

  resources :posts
  post '/callback' => 'linebot#callback'
end