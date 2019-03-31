Rails.application.routes.draw do
  resources :reviews
  resources :transactions
  devise_for :users

  resources :categories
  resources :orders
  resources :suppliers do
    member do
      patch 'disable'
      patch 'revoke'
      patch 'activate'
    end
  end
  resources :products
  resources :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  authenticated :user, ->(u) { u.manager? } do
    root to: "orders#index", as: :manager_root
  end

  authenticated :user, ->(u) { u.customer? } do
    root to: "home#customer_dashboard", as: :customer_root
  end

  root 'orders#index'


  get 'renew/:id' => 'orders#renew'
  get 'return/:id' => 'orders#return'
  get 'past_orders' => 'orders#old'
end
