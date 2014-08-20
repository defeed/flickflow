Rails.application.routes.draw do
  namespace :admin do
    get 'fetch' => 'movies#fetch', as: 'fetch'
    resources :movies, :people, :lists, :users
    match "/jobs" => DelayedJobWeb, :anchor => false, via: [:get, :post], as: 'jobs'
    root 'dashboard#index'
  end
  
  constraints subdomain: 'api' do
    namespace :api, path: '/' do
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
    end
  end
  
  root 'movies#index'
end
