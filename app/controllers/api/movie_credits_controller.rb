module API
  class MovieCreditsController < ApplicationController
    # GET /people/:id/movie_credits
    def index
      person = Person.find params[:person_id]
      @jobs = person.participations.group_by &:job
    end
  end
end
