class User < ActiveRecord::Base
  has_many :reviews, -> { order('created_at DESC') }
  has_many :queue_items, -> { order('position')}
  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password_digest, presence: true
  validates :password, length: { minimum: 3 }
  has_secure_password

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end

  def queue_items_include?(queue_item)
    queue_items.include?(queue_item)
  end

  def normalize_position_number
    queue_items.each_with_index do |item, index|
      item.update_attribute(:position, index+1)
    end
  end

  def update_queue_item_position(item_id, new_position)
    item = QueueItem.find(item_id)
    if queue_items.include?(item)
      item.position = new_position
      item.save!
    else
      raise 'You can only re-order videos in your queue.'
    end
  end

  def new_queue_item_position
    queue_items.count + 1
  end
end
