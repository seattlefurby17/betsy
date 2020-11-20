Rails.application.routes.draw do

  root to: "homepages#index"
  resources :homepages
  resources :merchants
  resources :order_items
  resources :orders
  resources :products

  # Nested route to create product for a merchant
  resources :merchants do
    resources :products, only: [:new, :create]
  end
  
  # resources :categories

  resources :products, except: [:destroy, :new, :create] # Called retire for clarity
  delete '/products/:id', to: 'merchants#retire', as: 'retire_product'

  get '/auth/:provider/callback', to: 'merchants#create', as: 'auth_callback'
  get '/auth/github', as: 'github_login'
  
  delete '/logout', to: 'merchants#destroy', as: 'logout'

  # get 'homepages/index'
  # get 'order_items/index'
  # get 'orders/index'
  # get 'products/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end
