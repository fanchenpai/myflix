class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  #validates_uniqueness_of :position, scope: :user_id

  delegate :category, to: :video
  delegate :category_name, to: :video
  delegate :title, to: :video, prefix: :video

  def rating
    review = Review.where(user: user, video: video).first
    review.rating unless review.nil?
  end

  def self.update_position(id, new_position)
    QueueItem.update(id, position: new_position)
  end


end
