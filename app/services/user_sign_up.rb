class UserSignUp

  attr_reader :error_message, :invitation

  def initialize(user)
    @user = user
    @invitation = nil
    self
  end

  def sign_up(stripe_token, invitation_token=nil)
    @invitation = Invitation.find_by_token(invitation_token) if invitation_token
    if @user.valid?
      unless process_payment(stripe_token)
        return self
      end
      @user.save
      redeem_invitation
      UserMailer.delay.welcome_email(@user.id)
      @status = :success
    else
      @error_message = 'Please correct the highlighted field(s).'
    end
    self
  end

  def user_id
    @user.id
  end

  def successful?
    @status == :success
  end

  private

  def redeem_invitation
    if @invitation
      establish_friendship(@invitation.user, @user)
      @invitation.fulfilled(@user)
    end
  end

  def establish_friendship(user1, user2)
    user1.follow(user2)
    user2.follow(user1)
  end

  def process_payment(token)
    charge = StripeWrapper::Charge.create(
      amount: 999,
      card: token,
      description: "Sign up charge for #{@user.email}"
    )
    if charge.successful?
      true
    else
      @error_message = charge.error_message
      false
    end
  end
end
