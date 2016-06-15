Rails.application.routes.draw do
  devise_for :users
  root 'products#index'
  resources :products , only: [:index, :new, :show, :create]
  resources :users , only: [:show, :edit, :update]
end
