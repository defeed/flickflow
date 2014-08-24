class APIController < ApplicationController
  protect_from_forgery with: :null_session
  
  before_action :authenticate_token
  
  protected
  
  def authenticate_token
    authenticate_or_request_with_http_token do |token, options|
      auth_token = AuthToken.find_by(token: token)
      auth_token && auth_token.user
    end
  end
end
