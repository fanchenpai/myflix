class FollowershipsController < AuthenticatedController

  def index
    @leaderships = current_user.leaderships
  end

  def create
    user = User.find(params[:following])
    if current_user.follow(user)
      flash[:notice] = 'You are now following this user'
    end
    redirect_to user_path(user)
  end

  def destroy
    followership = Followership.find(params[:id])
    followership.destroy if followership.follower == current_user
    redirect_to followerships_path
  end
end
