Rails.application.routes.draw do
  devise_for :users
  root 'shift#index'
  get '/profile', to: 'shift#profile'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
