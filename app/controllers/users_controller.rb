class UsersController < ApplicationController
  layout 'pages'
  skip_before_action :require_login, only: [:new, :create]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    
    if @user.save
      auto_login @user
      redirect_to root_path, flash: { success: "Alright! You've sucessfully created your profile on flickflow. Now go discover some good movies and add them to your Watchlist." }
    else
      render action: :new
    end
  end

  private
  
  def user_params
    params.require(:user).
      permit(:name, :username, :email, :password, :password_confirmation)
  end
end
