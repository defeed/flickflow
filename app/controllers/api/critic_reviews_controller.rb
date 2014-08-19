module API
  class CriticReviewsController < ApplicationController
    # GET /movies/:id/critic_reviews
    def index
      movie = Movie.find params[:movie_id]
      @reviews = movie.critic_reviews
    end
  end
end
