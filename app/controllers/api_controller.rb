class APIController < ApplicationController
  protect_from_forgery with: :null_session
  
  before_action :authenticate_token
  
  rescue_from CanCan::AccessDenied do |exception|
    render json: 'Unauthorized' , status: 401
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
        nil
      end
    end
  end
end
