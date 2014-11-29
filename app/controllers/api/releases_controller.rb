module API
  class ReleasesController < APIController
    # GET /movies/:movie_id/releases
    # GET /movies/:movie_id/releases?country_code=xx
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
