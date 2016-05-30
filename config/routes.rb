Rails.application.routes.draw do
  root 'products#index'
  resouces :products , only: [:index, :new, :show]
end
