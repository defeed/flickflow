class Admin::MoviesController < AdminController
  def index
    @movies = Movie.with_title.paginate(page: params[:page], per_page: 72).order('released_on DESC')
    @movie_count = @movies.count
  end

  def show
    @movie = Movie.friendly.find(params[:id])
    @directors = @movie.directorships.limit(3)
    @writers = @movie.writerships.limit(3)
    @actors = @movie.actorships.limit(15)
  end

  def fetch
    Movie.fetch params[:imdb_id]
    redirect_to admin_root_path
  end
end
