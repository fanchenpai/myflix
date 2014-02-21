class PasswordResetsController < ApplicationController
  before_action :find_user, only: [:show, :update]

  def create
    @user = User.search_by_email(params[:email])
    if @user
      @user.generate_password_token
      UserMailer.password_reset_email(@user).deliver
    else
      flash[:error] = "The email you provided is not in our system."
      redirect_to :forgot_password
    end
  end

  def show
    render :invalid_token if token_invalid?
  end

  def update
    if token_invalid?
      render :invalid_token
    else
      @user.update_attributes(password_params)
      if @user.errors.any?
        render :show
      else
        @user.clear_password_token
        flash[:success] = 'Your password has been reset.'
        redirect_to :sign_in
      end
    end
  end

  private

  def find_user
    @user = User.find_by_password_token(params[:token])
  end

  def token_invalid?
    @user.nil? || @user.token_expired?
  end

  def password_params
    params.require(:user)
          .permit(:password,:password_confirmation)
  end

end
