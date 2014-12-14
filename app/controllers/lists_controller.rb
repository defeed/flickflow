class ListsController < ApplicationController
  def show
    find_user_lists
    @list = current_user.lists.friendly.find(params[:id])

    @movies = @list.movies.with_title
              .includes(:genres)
              .includes(:primary_poster)
              .order('released_on DESC')
              .paginate(page: params[:page], per_page: 42)
  end
end
