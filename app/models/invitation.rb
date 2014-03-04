class Invitation < ActiveRecord::Base
  include Tokenable

  belongs_to :user
  validates_presence_of :email, :user_id

  def fulfilled(user)
    clear_token
    update_attribute(:new_user_id, user.id)
  end

end
