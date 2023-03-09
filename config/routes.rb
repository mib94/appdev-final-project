Rails.application.routes.draw do
  resources :favorites
  resources :follow_requests
  resources :comments
  resources :reviews
  resources :movies
  resources :users, except: :create
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post "toggle" => "favorites#toggle", as: :toggle
  get "feed" => "movies#feed", as: :feed
  get "discover" => "movies#discover", as: :discover
end
