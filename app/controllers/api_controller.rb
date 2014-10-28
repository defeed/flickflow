class APIController < ApplicationController
  protect_from_forgery with: :null_session
  
  skip_before_action :require_login, :redirect_to_profile
  before_action :authenticate_token
  
  rescue_from CanCan::AccessDenied do
    render json: {error: 'Unauthorized'} , status: 401
  end
  
  rescue_from ActiveRecord::RecordNotFound do
    render json: {error: 'Not Found'}, status: 404
  end
  
  private
  
  def current_user
    @current_user ||= authenticate_token
  end
  
  def authenticate_token
    authenticate_or_request_with_http_token do |token, options|
      auth_token = AuthToken.find_by(token: token)
      if auth_token && auth_token.user
        auto_login(auth_token.user)
        auth_token.user
      else
        raise CanCan::AccessDenied
      end
    end
  end
end
