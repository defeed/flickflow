class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :require_login
  before_action :set_api_token
  before_action :redirect_to_profile

  def find_user_lists
    @watchlist = current_user.lists.friendly.find('watchlist')
    @watched = current_user.lists.friendly.find('watched')
    @favorites = current_user.lists.friendly.find('favorites')
    @watchlist_movies = @watchlist.movies.map(&:id)
    @watched_movies = @watched.movies.map(&:id)
    @favorite_movies = @favorites.movies.map(&:id)
  end

  private

  def redirect_to_profile
    if current_user
      if [current_user.email, current_user.crypted_password].any?(&:blank?)
        missing_attributes = []
        missing_attributes << 'email' if current_user.email.blank?
        missing_attributes << 'password' if current_user.crypted_password.blank?
        redirect_to profile_path,
                    flash: {
                      error: "Almost done. Please set your #{missing_attributes.join(' and ')} to continue."
                    }
      end
    end
  end

  def not_authenticated
    redirect_to signin_path,
                flash: { error: 'You need to sign in to access flickflow.' }
  end

  def set_api_token
    gon.api_token = current_user && current_user.api_token
  end
end
