module API
  class ReleasesController < ApplicationController
    # GET /movies/:id/releases
    # GET /movies/:id/releases?country_code=xx
    def index
      movie = Movie.find params[:movie_id]
      @releases = movie.releases
      
      if country_code = params[:country_code]
        country = Country.find_by(code: country_code)
        @releases = @releases.where(country: country)
      end
    end
  end
end
