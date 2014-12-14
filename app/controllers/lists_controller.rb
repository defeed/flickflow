class ListsController < ApplicationController
  def show
    @list = current_user.lists.friendly.find(params[:id])
    @watchlist = current_user.lists.friendly.find('watchlist')
    @watched   = current_user.lists.friendly.find('watched')

    @movies = @list.movies.with_title
              .includes(:genres)
              .includes(:primary_poster)
              .order('released_on DESC')
              .paginate(page: params[:page], per_page: 42)
    @watchlist_movies = @watchlist.movies.map(&:id)
    @watched_movies = @watched.movies.map(&:id)
  end
end
