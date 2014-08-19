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
          resources :alternative_titles
          resources :credits
          resources :critic_reviews
          resources :genres
          resources :keywords
          resources :posters
          resources :releases
          resources :trivia
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
