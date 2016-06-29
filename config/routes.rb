Rails.application.routes.draw do
  devise_for :users
  root 'products#index'
  namespace :products do
    resources :popular, only: [:index]
  end

  resources :products do
    resources :likes, only: [:create, :destroy]
    resources :comments
  end
  resources :users , only: [:show, :edit, :update]
end
