class Followership < ActiveRecord::Base
  belongs_to :user
  belongs_to :follower, class_name: 'User'

  delegate :email, to: :user, prefix: :leader
  delegate :full_name, to: :user, prefix: :leader
  delegate :queue_items, to: :user, prefix: :leader
  delegate :followers, to: :user
end
