module API
  class GenresController < ApplicationController
    # GET /genres
    # GET /movies/:id/genres
    def index
      if movie_id = params[:movie_id]
        movie = Movie.find movie_id
        @genres = movie.genres
      else
        @genres = Genre.order :name
      end
    end
    
    # GET /genres/:id
    def show
      @genre = Genre.find params[:id]
    end
  end
end
