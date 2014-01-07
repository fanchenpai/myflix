class Category < ActiveRecord::Base
  has_many :videos
  validates :name, presence: true, uniqueness: { case_sensitive: false }

end