class SessionsController < ApplicationController
  def new #login form
    redirect_to videos_path if logged_in?
    @user = User.new
  end

  def create #login
    user = User.where('lower(email) = ?', params[:user][:email].downcase).first
    if user && user.authenticate(params[:user][:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome! You are now logged in."
      redirect_to videos_path
    else
      flash[:error] = "There's something wrong with your email/password. Please try again."
      redirect_to sign_in_path
    end

  end

  def destroy #logout
    flash[:notice] = "You've successfully logged out. Bye!" if logged_in?
    session[:user_id] = nil
    redirect_to root_path
  end

end
