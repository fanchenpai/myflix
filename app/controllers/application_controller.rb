class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :current_user
  helper_method :logged_in?

  def current_user
    @current_user ||=User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    unless logged_in?
      flash[:error] = "You are trying to access a member-only feature. Please sign in first."
      redirect_to sign_in_path
    end
  end

end
