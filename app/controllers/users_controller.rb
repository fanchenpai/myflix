class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def new_via_invitation
    @invitation = Invitation.find_by_token(params[:token])
    if @invitation
      @user = User.new(email: @invitation.email, full_name: @invitation.full_name)
      render :new
    else
      flash[:error] = "This invitation has expired."
      redirect_to register_path
    end
  end

  def create
    @user = User.new(user_params)
    @invitation = Invitation.find_by_token(params[:invitation]) if params[:invitation]
    if @user.save
      redeem_invitation
      flash[:success] = "Your account has been created."
      session[:user_id] = @user.id
      UserMailer.delay.welcome_email(@user.id)
      redirect_to videos_path
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user)
          .permit(:full_name,:email,:password,:password_confirmation)
  end

  def redeem_invitation
    if @invitation
      establish_friendship(@invitation.user, @user)
      @invitation.fulfilled(@user)
    end
  end

  def establish_friendship(user1, user2)
    user1.follow(user2)
    user2.follow(user1)
  end

end
