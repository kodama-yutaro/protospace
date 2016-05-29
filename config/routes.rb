Rails.application.routes.draw do
  root 'products#index'

  get  '/products/index'  =>    'products#index'
  get  '/products/new'    =>    'products#new'
  get  '/products/show'   =>    'products#show'
end
