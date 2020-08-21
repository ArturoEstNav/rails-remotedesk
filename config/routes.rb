Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users
  root to: 'pages#home'
  get '/offers', to: 'pages#home'
  resources :offers, only: [:show, :update]

  # Sidekiq Web UI, only for admins.
  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :users, only: [:show, :edit, :update] do
    resources :matches, only: [:index]
  end
  resources :matches, only: [:create, :destroy]
end
