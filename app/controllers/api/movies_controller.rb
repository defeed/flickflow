module API
  class MoviesController < ApplicationController
    # GET /movies
    # GET /genres/:id/movies
    # GET /keywords/:id/movies
    def index
      if genre_id = params[:genre_id]
        @movies = Genre.find(genre_id).movies
      elsif keyword_id = params[:keyword_id]
        @movies = Keyword.find(keyword_id).movies
      else
        @movies = Movie.all
      end
      
      if decade = params[:decade]
        @movies = @movies.where year: get_years_by_decade(decade)
      end
      
      if year = params[:year]
        @movies = @movies.where year: year
      end
      
      @movies.paginate page: params[:page]
    end
    
    # GET /movies/:id
    def show
      @movie = Movie.find params[:id]
      @primary_poster = @movie.primary_poster
      @directors = @movie.directors
      @starred_actors = @movie.stars
    end
    
    private
    
    def get_years_by_decade(decade)
      decade = decade.to_i
      (decade..decade+9)
    end
  end
end
