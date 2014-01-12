class PagesController < ApplicationController

  def front
    redirect_to videos_path if logged_in?
  end

end
