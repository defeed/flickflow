module API
  class RecommendedMoviesController < ApplicationController
    # GET /movies/:id/recommended_movies
    def index
      movie = Movie.find params[:movie_id]
      @movies = movie.recommended_movies
    end
  end
end
