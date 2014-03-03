module Tokenable
  extend ActiveSupport::Concern

  included do
    before_create :generate_token
  end

  def clear_token
    self.token = nil
    self.token_timestamp = nil
    self.save!(validate:false)
  end

  def generate_token(autosave=false)
    self.token = SecureRandom.urlsafe_base64
    self.token_timestamp = Time.now
    self.save!(validate:false) if autosave
  end

  def token_expired?(lifespan)
    if self.token_timestamp + lifespan < Time.now
      clear_token
      true
    else
      false
    end
  end

end

