class UsersController < AuthenticatedController
  skip_before_action :ensure_log_in , except: [:show]

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
    result = UserSignUp.new(@user).sign_up(params[:stripeToken], params[:invitation])
    if result.successful?
      session[:user_id] = result.user_id
      flash[:success] = "Your account has been created."
      redirect_to videos_path
    else
      @invitation = result.invitation
      flash[:error] = result.error_message
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

end
