Rails.application.routes.draw do

  devise_for :users
  root to: "homes#top"
  resources :books do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
    resource :tags, only: [:create, :destroy]
    get :search, on: :collection
  end
  resources :users, only: [:index, :show, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
    get "relationships/followings" => "relationships#followings", as: "followings"
    get "relationships/followers" => "relationships#followers", as: "followers"
  end
  get "search" => "searches#search"
  get "home/about" => "homes#about", as: "about"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end