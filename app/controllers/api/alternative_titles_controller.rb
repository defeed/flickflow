module API
  class AlternativeTitlesController < ApplicationController
    # GET /movies/:id/alternative_titles
    def index
      movie = Movie.find params[:movie_id]
      @titles = movie.alternative_titles
    end
  end
end
