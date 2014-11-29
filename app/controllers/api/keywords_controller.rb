module API
  class KeywordsController < APIController
    # GET /keywords
    # GET /movies/:movie_id/keywords
    def index
      if movie_id = params[:movie_id]
        movie = Movie.find movie_id
        @keywords = movie.keywords
      else
        @keywords = Keyword.order :name
      end
    end

    # GET /keywords/:id
    def show
      @keyword = Keyword.find params[:id]
    end
  end
end
