class Admin::MoviesController < AdminController
  def index
    @movies = Movie.paginate(page: params[:page], per_page: 72).order('released_on DESC')
  end
  
  def show
    @movie = Movie.friendly.find(params[:id])
  end
end
