class QueueItemsController < AuthenticatedController

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    queue_video(video)
    redirect_to my_queue_path
  end

  def update_queue
    update_queue_item
    redirect_to my_queue_path
  end

  def destroy
    delete_queue_item
    redirect_to my_queue_path
  end

  private

  def queue_video(video)
    if current_user.queued_video?(video)
      flash[:error] = "This video is already in [My Queue]."
    else
      QueueItem.create(video: video, user:current_user, position: current_user.new_queue_item_position)
      flash[:notice] = "Video added to [My Queue]."
    end
  end

  def update_queue_item
    begin
      ActiveRecord::Base.transaction do
        params[:queue_items].each do |item_param|
          current_user.update_queue_item(item_param['id'], item_param['position'], item_param['rating'])
        end
        current_user.normalize_position_number
      end
    rescue ActiveRecord::RecordInvalid
      flash[:error] = 'Invalid postion number format'
    rescue Exception => e
      flash[:error] = e.message
    end
  end

  def delete_queue_item
    ActiveRecord::Base.transaction do
      queue_item = QueueItem.find(params[:id])
      queue_item.destroy if current_user.queue_items_include?(queue_item)
      current_user.normalize_position_number
    end
  end

end
