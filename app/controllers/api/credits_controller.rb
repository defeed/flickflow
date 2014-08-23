module API
  class CreditsController < APIController
    # GET /movies/:movie_id/credits
    def index
      movie = Movie.find params[:movie_id]
      @jobs = movie.participations.group_by &:job
    end
  end
end
