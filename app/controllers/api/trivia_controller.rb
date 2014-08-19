module API
  class TriviaController < ApplicationController
    # GET /movies/:id/trivia
    def index
      movie = Movie.find params[:movie_id]
      @trivia = movie.trivia
    end
  end
end
