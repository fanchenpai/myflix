class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  validates_presence_of :rating,:detail,:user_id, :video_id
  validates_uniqueness_of :user_id, scope: :video_id

  def creator_name
    self.user.full_name unless self.user.nil?
  end

end
