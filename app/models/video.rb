class Video < ActiveRecord::Base
  default_scope -> { order('created_at DESC') }
  belongs_to :category
  has_many :reviews, -> { order('created_at DESC') }
  validates :title, presence: true
  validates :category_id, presence: true

  delegate :name, to: :category, prefix: :category


  def average_rating
    reviews.average(:rating).round(1).to_s unless reviews.empty?
  end

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    Video.where('title LIKE ?', "%#{search_term}%").order('created_at DESC')
  end

end
