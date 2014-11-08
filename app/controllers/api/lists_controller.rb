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
      user_lists = current_user.lists
      
      if movie_id = params[:movie_id]
        @object = Movie.find(movie_id)
      elsif person_id = params[:person_id]
        @object = Person.find(person_id)
      end
      
      @list.toggle(@object)
      
      if @object.is_a?(Movie)
        watchlist = user_lists.detect { |list| list.name == 'Watchlist' }
        watched   = user_lists.detect { |list| list.name == 'Watched' }
        favorites = user_lists.detect { |list| list.name == 'Favorites' }
        
        if @list == watched
          if watched.includes?(@object) && watchlist.includes?(@object)
            watchlist.remove(@object)
          elsif !watched.includes?(@object) && favorites.includes?(@object)
            favorites.remove(@object)
          end
        end
        
        @lists = current_user.lists.movie
      elsif object.is_a?(Person)
        @lists = current_user.lists.person
      end
    end
    
    private
    
    def list_params
      params.require(:list).permit(:name, :is_private)
    end
  end
end
