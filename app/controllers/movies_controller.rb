class MoviesController < ApplicationController
  def index
    @movies = Movie.with_title.paginate(page: params[:page], per_page: 72).order('released_on DESC')
    @watchlist = current_user.lists.friendly.find('watchlist')
    @watched   = current_user.lists.friendly.find('watched')
  end
  
  def show
    @movie = Movie.friendly.find(params[:id])
    @title = @movie.title
    @trailer = @movie.trailers.first
    @lists = current_user.lists
    @watchlist = current_user.lists.friendly.find('watchlist')
    @watched   = current_user.lists.friendly.find('watched')
    @favorites = current_user.lists.friendly.find('favorites')
    @in_watchlist = @watchlist.includes? @movie
    @in_watched   = @watched.includes? @movie
    @in_favorites = @favorites.includes? @movie
  end
end
