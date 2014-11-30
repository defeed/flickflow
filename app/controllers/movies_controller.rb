class MoviesController < ApplicationController
  def index
    @movies = Movie.with_title.released.with_pop_index
              .includes(:genres)
              .includes(:primary_poster)
              .order('pop_index')
              .paginate(page: params[:page], per_page: 42)
    @watchlist_movies = current_user.lists.friendly
                        .find('watchlist').movies.map(&:id)
    @watched_movies = current_user.lists.friendly
                      .find('watched').movies.map(&:id)
  end

  def show
    @movie = Movie.friendly.find(params[:id])
    @title = @movie.title
    @trailer = @movie.trailers.first
    @watchlist = current_user.lists.friendly.find('watchlist')
    @favorites = current_user.lists.friendly.find('favorites')
    @watched = current_user.lists.friendly.find('watched')
    @watchlist_movies = @watchlist.movies.map(&:id)
    @favorite_movies = @favorites.movies.map(&:id)
    @watched_movies = @watched.movies.map(&:id)
    @recommended_movies = @movie.recommended_movies.with_title
                          .includes(:genres)
                          .includes(:primary_poster)
                          .order('released_on DESC')
  end
end
