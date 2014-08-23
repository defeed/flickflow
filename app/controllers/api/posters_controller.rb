module API
  class PostersController < APIController
    # GET /movies/:movie_id/posters
    def index
      movie = Movie.find params[:movie_id]
      @posters = movie.posters
    end
  end
end
