class User < ActiveRecord::Base
  has_many :reviews, -> { order('created_at DESC') }
  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: /\A[-0-9a-zA-Z.+_]+@[-0-9a-zA-Z.+_]+\.[a-zA-Z]{2,4}\z/ }
  validates :password_digest, presence: true
  validates :password, length: { minimum: 3 }
  has_secure_password
end
