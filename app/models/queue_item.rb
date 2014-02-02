class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  validates_numericality_of :position, only_integer: true

  delegate :category, to: :video
  delegate :category_name, to: :video
  delegate :title, to: :video, prefix: :video
  delegate :id, to: :video, prefix: :video

  def rating
    review = Review.where(user: user, video: video).first
    review.rating unless review.nil?
  end

  def rating= (new_rating)
    review = Review.find_or_initialize_by(user: user, video: video)
    review.rating = new_rating
    review.save!(validate: false)
  end

end
