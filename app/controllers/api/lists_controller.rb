module API
  class ListsController < APIController
    # GET /users/:user_id/lists/:list_id
    def show
      list = List.find params[:id]
      render json: list, status: 200
    end
    
    # POST /users/:user_id/lists
    def create
      user = User.find params[:user_id]
      list = user.lists.new(list_params)
      
      if list.save
        head 204, location: api_user_list_path(user, list)
      else
        render json: list.errors, status: 422
      end
    end
    
    # PATCH /users/:user_id/lists/:list_id
    def update
      user = User.find params[:user_id]
      list = List.find params[:id]
      
      if list.update(list_params)
        head 204, location: api_user_list_path(user, list)
      else
        render json: list.errors, status: 422
      end
    end
    
    # DELETE /users/user_id/lists/:list_id
    def destroy
      user = User.find params[:user_id]
      list = List.find params[:id]
      list.destroy
      head 204
    end
    
    # POST /users/:user_id/lists/:list_id/movies/:movie_id/toggle_movie
    def toggle_movie
      user = User.find params[:user_id]
      list = List.find params[:list_id]
      movie = Movie.find params[:movie_id]
      
      if list.toggle_entry(user, movie)
        head 204, location: api_user_list_path(user, list)
      end
    end
    
    private
    
    def list_params
      params.require(:list).permit(:name, :list_type, :is_private)
    end
  end
end
