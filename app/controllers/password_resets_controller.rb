class PasswordResetsController < ApplicationController

  def new

  end

  def create
    @user = User.find_by_email(params[:email])
    unless @user.nil?
      @user.generate_password_token
      @user.save!(validate:false)
      UserMailer.password_reset_email(@user).deliver
    end
  end

  def show

  end

  def destroy

  end


end
