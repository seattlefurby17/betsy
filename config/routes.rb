Rails.application.routes.draw do

  root to: "homepages#index"
  # TODO remove unused routes
  resources :homepages
  resources :merchants
  resources :order_items
  resources :orders, except: :show
  resources :products, except: :destroy # Called retire for clarity
  delete '/products/:id', to: 'merchants#retire', as: 'retire_product'
# TODO ^^ Move to products controller?
  # resources :categories

  # Login stuff
  get '/auth/:provider/callback', to: 'merchants#create', as: 'auth_callback'
  get '/auth/github', as: 'github_login'
  delete '/logout', to: 'merchants#destroy', as: 'logout'

  # Cart stuff
  get '/cart', to: 'orders#cart', as: 'cart'
  patch '/cart/edit_quantity/:id', to: 'order_items#edit_quantity', as: 'edit_quantity'
  patch '/cart/:id', to: 'order_items#add_to_cart', as: 'add_cart'

  # get 'homepages/index'
  # get 'order_items/index'
  # get 'orders/index'
  # get 'products/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end
