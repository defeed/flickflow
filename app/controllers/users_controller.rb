class UsersController < ApplicationController
  layout 'pages'
  skip_before_action :require_login, only: [:new, :create]
  skip_before_action :redirect_to_profile, only: [:edit, :update]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    
    if @user.save
      auto_login @user
      redirect_to root_path, flash: { success: "Alright! You've successfully created your profile on flickflow. Now go discover some good movies and add them to your Watchlist." }
    else
      render action: :new
    end
  end
  
  def edit
    @user = current_user
    has_password = @user.crypted_password.present?
    @password_label = has_password ? 'Change password' : 'Create password'
    @password_placeholder = has_password ? 'Type new password to change it' : nil
    render layout: 'application'
  end
  
  def update
    @user = current_user
    
    if @user.update user_params
      redirect_to root_path, flash: { success: 'Your profile was successfully updated.' }
    else
      render action: :edit, layout: 'application'
    end
  end

  private
  
  def user_params
    params.require(:user).
      permit(:name, :username, :email, :password, :password_confirmation)
  end
end
