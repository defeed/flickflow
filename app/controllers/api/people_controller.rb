module API
  class PeopleController < APIController
    # GET /people/:id
    def show
      @person = Person.find params[:id]
    end
  end
end
