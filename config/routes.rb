Rails.application.routes.draw do
  get 'category/index'
  get 'admin' => 'admin#index'
  get 'categories', to: 'categories#index'
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :support_requests, only: %i[index update]

  get '/users/orders', to: 'users#orders'
  get '/users/line_items', to: 'users#line_items', defaults: { page_id: 1 }
  get '/users/line_items/page/:page_id', to: 'users#line_items'

  namespace :admin do
    get 'categories', to: 'categories#index'
    get 'reports', to: 'reports#index'
  end

  scope '(:locale)' do
    resources :orders
    resources :users
    resources :line_items
    resources :carts
    resources :products
    root 'store#index', as: 'store_index', via: :all
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
