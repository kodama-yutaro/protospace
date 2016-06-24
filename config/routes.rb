Rails.application.routes.draw do
  devise_for :users
  root 'products#index'
  resources :products do
    resources :likes, only: [:create, :destroy]
  end
  resources :users , only: [:show, :edit, :update]
end
