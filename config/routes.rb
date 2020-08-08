Rails.application.routes.draw do
  get 'offers/index'
  get 'offers/show'
  get 'users/show'
  get 'users/edit'
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :offers, only: [:index, :show]

  resources :users, only: [:show, :edit] do
    resources :matches, only: [:index], shallow: true
  end
end
