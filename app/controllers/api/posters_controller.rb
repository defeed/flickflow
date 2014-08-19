module API
  class PostersController < ApplicationController
    # GET /movies/:id/posters
    def index
      movie = Movie.find params[:movie_id]
      @posters = movie.posters
    end
  end
end
