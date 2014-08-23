module API
  class AlternativeTitlesController < APIController
    # GET /movies/:movie_id/alternative_titles
    def index
      movie = Movie.find params[:movie_id]
      @titles = movie.alternative_titles
    end
  end
end
