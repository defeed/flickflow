module API
  class PeopleController < ApplicationController
    # GET /people/:id
    def show
      @person = Person.find params[:id]
    end
  end
end
