class SessionsController < ApplicationController
  layout 'pages'
  skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
    @title = 'Sign In'
  end

  def create
    if @user = login(params[:email], params[:password], params[:remember])
      redirect_back_or_to root_path
    else
      @title = 'Sign In'
      flash.now[:error] =
        'Provided email/username or password are invalid. Try again.'
      render action: :new
    end
  end

  def destroy
    logout
    redirect_to signin_path, notice: "You've been signed out. See you!"
  end
end
