class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    if queue_item_exists?(video, current_user)
      flash[:error] = "This video is already in [My Queue]."
      redirect_to my_queue_path
      return
    end
    queue_item = QueueItem.new(video: video, user:current_user, position: new_queue_item_position)
    if queue_item.save
      flash[:notice] = "Video added to [My Queue]."
      redirect_to my_queue_path
    else
      flash[:error] = "Action failed."
      redirect_to video_path(video)
    end
  end

  private

  def new_queue_item_position
    current_max = current_user.queue_items.maximum(:position)
    current_max.nil? ? 1 : current_max + 1
  end

  def queue_item_exists?(video, user)
    not_found = QueueItem.where('user_id=? AND video_id=?', user.id, video.id).empty?
    !not_found
  end

end
