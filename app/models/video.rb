class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order('created_at DESC') }
  validates :title, presence: true
  validates :category_id, presence: true

  def category_name
    self.category.name unless self.category.nil?
  end

  def average_rating
    self.reviews.average(:rating).round(1).to_s unless self.reviews.empty?
  end

  # def user_rating(user_id)
  #   review = self.reviews.find_by user_id: user_id
  #   review.rating unless review.nil?
  # end

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    Video.where('title LIKE ?', "%#{search_term}%").order('created_at DESC')
  end

end
