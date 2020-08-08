Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :offers, only: [:index, :show, :update]

  resources :users, only: [:show, :edit] do
    resources :matches, only: [:index]
  end
  resources :matches, only: [:create]
end
