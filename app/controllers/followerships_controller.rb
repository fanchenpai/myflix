class FollowershipsController < ApplicationController
  before_action :require_user
  def index
    @leaderships = current_user.leaderships
  end

  def create
    user = User.find(params[:following])
    unless current_user.leaders.include?(user)
      followership = user.followerships.build(follower: current_user)
      if followership.save
        flash[:notice] = 'You are now following this user'
      end
    end
    redirect_to user_path(user)
  end

  def destroy
    followership = Followership.find(params[:id])
    followership.destroy if followership.follower == current_user
    redirect_to followerships_path
  end
end
