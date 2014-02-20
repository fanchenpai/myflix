class PasswordResetsController < ApplicationController

  def new

  end

  def create
    @user = User.search_by_email(params[:email])
    unless @user.nil?
      @user.generate_password_token
      UserMailer.password_reset_email(@user).deliver
    end
  end

  def show
    @user = User.find_by_password_token(params[:token])
    if @user.nil? || @user.token_expired?
      render :invalid_token
    end
  end

  def destroy

  end


end
