class User < ActiveRecord::Base
  validates_presence_of :email, :full_name, :password_digest
  validates_uniqueness_of :email, case_sensitive: false
  has_secure_password
end