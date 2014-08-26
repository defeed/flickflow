module API
  class ListsController < APIController
    load_and_authorize_resource :list
    
    # GET /api/lists/:id
    # GET /api/users/:user_id/lists/:id
    def show; end
    
    # POST /api/lists
    # @params list_type
    def create
      @list = current_user.lists.new(list_params)
      @list.list_type = params[:type].presence || 'movie'
      
      if @list.save
        head 204, location: api_user_list_path(@list.user, @list)
      else
        render json: @list.errors, status: 422
      end
    end
    
    # PATCH /api/lists/:id
    def update
      if @list.update(list_params)
        head 204, location: api_user_list_path(@list.user, @list)
      else
        render json: @list.errors, status: 422
      end
    end
    
    # DELETE /api/lists/:id
    def destroy
      @list.destroy
      head 204
    end
    
    # POST /api/lists/:id/toggle
    # @params movie_id
    # @params person_id
    def toggle
      if movie_id = params[:movie_id]
        object = Movie.find movie_id
      elsif person_id = params[:person_id]
        object = Person.find person_id
      end
      
      @list.toggle object if object
      head 204, location: api_user_list_path(@list.user, @list)
    end
    
    private
    
    def list_params
      params.require(:list).permit(:name, :is_private)
    end
  end
end
