Rails.application.routes.draw do
  get 'stores/show'
  get 'stores/new'
  get 'stores/edit'
  post 'stores/create'
  patch 'stores/update'

  devise_for :users
  root 'shift#index'
  get 'profile', to: 'shift#profile'
  get 'requests/new', to: 'requests#new'
  post 'requests', to: 'requests#create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
