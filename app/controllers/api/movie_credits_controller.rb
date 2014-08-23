module API
  class MovieCreditsController < APIController
    # GET /people/:person_id/movie_credits
    def index
      person = Person.find params[:person_id]
      @jobs = person.participations.group_by &:job
    end
  end
end
