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

  # get '/users/orders'
  # get '/users/line_items(/*page)', to: 'users#line_items'

  scope '(:locale)' do
    resources :orders
    resources :users do
      collection do
        get 'orders'
        get 'line_items(/*page)', to: 'users#line_items'
      end
    end
    resources :line_items
    resources :carts
    resources :products, path: '/books'
    root 'store#index', as: 'store_index', via: :all
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
