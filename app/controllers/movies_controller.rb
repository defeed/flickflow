class MoviesController < ApplicationController
  def index
    find_user_lists
    @movies = Movie.with_title.released.with_pop_index
              .includes(:genres)
              .includes(:primary_poster)
              .order('pop_index')
              .paginate(page: params[:page], per_page: 42)
  end

  def show
    find_user_lists
    @movie = Movie.friendly.find(params[:id])
    @title = @movie.title
    @trailer = @movie.trailers.first
    @recommended_movies = @movie.recommended_movies.with_title
                          .includes(:genres)
                          .includes(:primary_poster)
  end
end
