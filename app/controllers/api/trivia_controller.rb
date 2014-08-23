module API
  class TriviaController < APIController
    # GET /movies/:movie_id/trivia
    def index
      movie = Movie.find params[:movie_id]
      @trivia = movie.trivia
    end
  end
end
