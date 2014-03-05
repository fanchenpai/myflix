class InvitationsController < ApplicationController
  before_action :require_user
  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params)
    if @invitation.save
      UserMailer.delay.invitation_email(@invitation.id)
      flash[:success] = "Your invitations has been sent."
      redirect_to :invite
    else
      render :new
    end
  end

  private

  def invitation_params
    params.require(:invitation)
          .permit(:full_name, :email, :message)
          .merge(user: current_user)
  end

end
