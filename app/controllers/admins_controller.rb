class AdminsController < AuthenticatedController
  before_action :ensure_admin

  def ensure_admin
    unless admin?
      flash[:error] = "You are trying to access a admin-only feature."
      redirect_to root_path
    end
  end
end
