require 'oauth2'
class OauthsController < ApplicationController
  skip_before_action :require_login

  def oauth
    login_at auth_params[:provider]
  end

  def callback
    provider = auth_params[:provider]
    begin
      if @user = login_from(provider)
        redirect_to root_path
      else
        begin
          @user = create_from(provider)
          # @user.activate!
          reset_session # protect from session fixation attack
          auto_login @user
          redirect_to root_path
        rescue
          redirect_to root_path,
                      flash: {
                        error: "Failed to sign in from #{provider.titleize}!"
                      }
        end
      end
    rescue ::OAuth2::Error => e
      p e
      puts e.code
      puts e.description
      puts e.message
      puts e.backtrace
    end
  end

  private

  def auth_params
    params.permit(:code, :provider)
  end
end
