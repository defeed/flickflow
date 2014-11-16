class ListsController < ApplicationController
  def show
    @list = current_user.lists.friendly.find(params[:id])
    @watchlist = current_user.lists.friendly.find('watchlist')
    @watched   = current_user.lists.friendly.find('watched')
    
    @movies = @list.movies.with_title.paginate(page: params[:page], per_page: 72).order('released_on DESC')
  end
end
