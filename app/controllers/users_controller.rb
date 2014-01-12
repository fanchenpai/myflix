class UsersController < ApplicationController

  def home

  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Your account has been created."
      redirect_to videos_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user)
          .permit(:full_name,:email,:password,:password_confirmation)
  end

end
