module API
  class GenresController < APIController
    # GET /genres
    # GET /movies/:movie_id/genres
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
