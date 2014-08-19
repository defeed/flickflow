module API
  class CreditsController < ApplicationController
    # GET /movies/:id/credits
    def index
      movie = Movie.find params[:movie_id]
      @jobs = movie.participations.group_by &:job
    end
  end
end
