class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  validates_presence_of :rating, :user_id, :video_id
  validates_uniqueness_of :user_id, scope: :video_id
end
