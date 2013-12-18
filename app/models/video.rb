class Video < ActiveRecord::Base
  belongs_to :category
  validates :title, presence: true
  validates :category_id, presence: true

  def category_name
    self.category.name unless self.category.nil?
  end

end