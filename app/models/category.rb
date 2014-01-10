class Category < ActiveRecord::Base
  has_many :videos, -> { order('title') }
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def recent_videos
    Video.where('category_id = ?', id).order('created_at DESC').limit(6)
  end

end