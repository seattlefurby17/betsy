Rails.application.routes.draw do

  root to: "homepages#index"
  resources :homepages
  resources :merchants
  resources :order_items
  resources :orders
  resources :products
  get '/auth/github', as: 'github_login'
  get '/auth/:provider/callback', to: 'merchants#create'

  # get 'homepages/index'
  # get 'order_items/index'
  # get 'orders/index'
  # get 'products/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end
