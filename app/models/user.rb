class User < ActiveRecord::Base
  has_many :reviews, -> { order('created_at DESC') }
  has_many :queue_items, -> { order('position')}
  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password_digest, presence: true
  validates :password, length: { minimum: 3 }
  has_secure_password
end
