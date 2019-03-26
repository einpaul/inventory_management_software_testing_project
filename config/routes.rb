Rails.application.routes.draw do
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

  root 'orders#index'

  get 'renew/:id' => 'orders#renew'
  get 'return/:id' => 'orders#return'
  get 'past_orders' => 'orders#old'
end
