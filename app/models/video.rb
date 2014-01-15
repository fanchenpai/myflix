class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews
  validates :title, presence: true
  validates :category_id, presence: true

  def category_name
    self.category.name unless self.category.nil?
  end

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    Video.where('title LIKE ?', "%#{search_term}%").order('created_at DESC')
  end

end
