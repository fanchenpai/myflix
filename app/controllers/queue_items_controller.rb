class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    queue_video(video)
    redirect_to my_queue_path
  end

  def update_queue
    begin
      ActiveRecord::Base.transaction do
        params[:queue_items].each do |item_param|
          update_queue_item_position(item_param['id'], item_param['position'])
        end
        normalize_position_number
      end
    rescue ActiveRecord::RecordInvalid
      flash[:error] = 'Invalid postion number format'
    rescue Exception => e
      flash[:error] = e.message
    end
    redirect_to my_queue_path
  end

  def destroy
    ActiveRecord::Base.transaction do
      queue_item = QueueItem.find(params[:id])
      queue_item.destroy if current_user.queue_items.include?(queue_item)
      normalize_position_number
    end
    redirect_to my_queue_path
  end

  private

  def queue_video(video)
    if current_user_queued_video?(video)
      flash[:error] = "This video is already in [My Queue]."
    else
      QueueItem.create(video: video, user:current_user, position: new_queue_item_position)
      flash[:notice] = "Video added to [My Queue]."
    end
  end

  def new_queue_item_position
    current_user.queue_items.count + 1
  end

  def current_user_queued_video?(video)
    current_user.queue_items.map(&:video).include?(video)
  end

  def normalize_position_number
    current_user.queue_items.each_with_index do |item, index|
      item.update_attribute(:position, index+1)
    end
  end

  def update_queue_item_position(item_id, new_position)
    item = QueueItem.find(item_id)
    if current_user.queue_items.include?(item)
      item.position = new_position
      item.save!
    else
      raise 'You can only re-order videos in your queue.'
    end
  end
end
