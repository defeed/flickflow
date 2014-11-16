Rails.application.routes.draw do
  namespace :admin do
    get 'fetch' => 'movies#fetch', as: 'fetch'
    resources :movies, :people, :lists, :users
    match "/jobs" => DelayedJobWeb, :anchor => false, via: [:get, :post], as: 'jobs'
    root 'dashboard#index'
  end
  
  namespace :api do
    resources :movies, only: [:index, :show] do
      with_options only: :index do |list_only|
        list_only.resources :alternative_titles
        list_only.resources :credits
        list_only.resources :critic_reviews
        list_only.resources :genres
        list_only.resources :keywords
        list_only.resources :posters
        list_only.resources :recommended_movies
        list_only.resources :releases
        list_only.resources :trivia
      end
    end
    
    resources :people, only: :show do
      resources :movie_credits, only: :index
    end
    
    resources :genres, only: [:index, :show] do
      resources :movies, only: :index
    end
    
    resources :keywords, only: [:index, :show] do
      resources :movies, only: :index
    end
    
    resources :users do
      resources :lists, only: :show
    end
    
    resources :lists do
      post 'toggle', on: :member
    end
  end
  
  resources :movies, only: [:index, :show]
  resources :users, only: [:new, :create, :edit, :update]
  resources :sessions, only: [:new, :create, :destroy]
  
  get 'watchlist' => 'lists#show', id: 'watchlist', as: :watchlist
  get 'watched'   => 'lists#show', id: 'watched', as: :watched
  get 'favorites' => 'lists#show', id: 'favorites', as: :favorites
  
  get 'sign-in' => 'sessions#new', as: :signin
  delete 'sign-out' => 'sessions#destroy', as: :signout
  get 'join' => 'users#new', as: :join
  
  post 'oauth/callback' => 'oauths#callback'
  get 'oauth/callback' => 'oauths#callback'
  get 'oauth/:provider' => 'oauths#oauth',  as: :auth_at_provider
  
  get 'profile' => 'users#edit', as: :profile
  post 'profile' => 'users#update'
  
  root 'movies#index'
end
