class User < ActiveRecord::Base
  has_many :reviews, -> { order('created_at DESC') }
  has_many :queue_items, -> { order('position') }
  has_many :followerships
  has_many :followers, -> { order('created_at DESC') }, through: :followerships
  has_many :leaderships, class_name: 'Followership', foreign_key: 'follower_id'
  has_many :leaders, -> { order('created_at DESC') }, through: :leaderships, source: :user
  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password_digest, presence: true
  validates :password, length: { minimum: 3 }
  has_secure_password

  TOKEN_VALID_PERIOD = 1.day

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end

  def queue_items_include?(queue_item)
    queue_items.include?(queue_item)
  end

  def normalize_position_number
    queue_items.each_with_index do |item, index|
      item.update_attribute(:position, index+1)
    end
  end

  def update_queue_item(item_id, new_position, new_rating=nil)
    item = QueueItem.find(item_id)
    if queue_items.include?(item)
      item.position = new_position
      item.rating = new_rating if new_rating.to_i > 0
      item.save!
    else
      raise 'You can only manage videos in your queue.'
    end
  end

  def new_queue_item_position
    queue_items.count + 1
  end

  def following?(user)
    leaders.include?(user)
  end

  def can_follow?(user)
    !following?(user) && self != user
  end

  def generate_password_token
    self.password_token = SecureRandom.urlsafe_base64
    self.password_token_timestamp = Time.now
    self.save!(validate:false)
  end

  def clear_password_token
    self.password_token = nil
    self.password_token_timestamp = nil
    self.save!(validate: false)
  end

  def token_expired?
    if self.password_token_timestamp + TOKEN_VALID_PERIOD < Time.now
      clear_password_token
      true
    else
      false
    end
  end

  def self.search_by_email(email)
    User.where('lower(email) = ?', email.downcase).first
  end

end
