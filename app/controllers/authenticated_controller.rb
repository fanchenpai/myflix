class AuthenticatedController < ApplicationController
  before_action :ensure_log_in

  def ensure_log_in
    unless logged_in?
      flash[:error] = "You are trying to access a member-only feature. Please sign in first."
      redirect_to sign_in_path
    end
  end

end
