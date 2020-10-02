Rails.application.routes.draw do
  get 'stores/show'
  get 'stores/new'
  get 'stores/edit'
  post 'stores/create'
  patch 'stores/update'

  # devise_for :users
  # 上書きが必要なコントローラだけルーティング設定を行う（おそらく
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  # devise_scope :user do
  #   get 'users/:id/edit' => 'users/registrations#edit', as: :edit_other_user_registration
  #   match 'users/:id', to: 'users/registrations#update', via: [:patch, :put], as: :other_user_registration
  # end

  # 以下の設定でrootをログイン画面にする
  # unauthenticated do
  #   as :user do
  #     root to: 'devise/sessions#new'
  #   end
  # end
  root to: 'shift#index'

  get 'profile', to: 'shift#profile'
  get 'users', to: 'shift#users'
  get 'requests/new', to: 'requests#new'
  post 'requests', to: 'requests#create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
