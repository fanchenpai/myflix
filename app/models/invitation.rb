class Invitation < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :email, :user_id
  before_create :generate_token

  TOKEN_VALID_PERIOD = 90.day

  def fulfilled(user)
    clear_token
    update_attribute(:new_user_id, user.id)
  end

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end

  def clear_token
    self.token = nil
    self.save!(validate: false)
  end

end
