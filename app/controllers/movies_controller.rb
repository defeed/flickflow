class MoviesController < ApplicationController
  def index
    @movies = Movie.with_title.paginate(page: params[:page], per_page: 72).order('released_on DESC')
    @movie_count = @movies.count
  end
end