Rails.application.routes.draw do
  root 'store#index', as: 'store_index', via: :all

  constraints(->(req) { !/Chrome/.match?(req.env['HTTP_USER_AGENT']) }) do
    get 'admin' => 'admin#index'

    resources :categories, only: [:index, :show], id: /\d+/
    resources :categories, to: redirect('/'), status: 302

    controller :sessions do
      get 'login' => :new
      post 'login' => :create
      delete 'logout' => :destroy
    end

    resources :support_requests, only: %i[index update]

    namespace :admin do
      get 'categories', to: 'categories#index'
      get 'reports', to: 'reports#index'
    end

    get 'my-orders', to: 'users#orders'
    get 'my-line-items(/*page)', to: 'users#line_items'
    
    scope '(:locale)' do
      resources :orders
      resources :users
      resources :line_items
      resources :carts
      resources :products, path: '/books'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
