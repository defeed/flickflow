module API
  class CriticReviewsController < APIController
    # GET /movies/:movie_id/critic_reviews
    def index
      movie = Movie.find params[:movie_id]
      @reviews = movie.critic_reviews
    end
  end
end
