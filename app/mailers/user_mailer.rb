class UserMailer < ActionMailer::Base
  default from: "customer_service@myflix.com"

  def welcome_email(user)
    @user = user
    @url = sign_in_url
    mail(to: @user.email,
         subject: 'Welcome to MyFLiX site!')
  end

  def password_reset_email(user)
    @token = user.token
    mail(to: user.email,
         subject: 'Reset your password')
  end

  def invitation_email(invitation)
    @invitation = invitation
    @user = invitation.user
    mail(to: invitation.email,
         subject: "#{@user.full_name} invites you to join MyFLiX!!")
  end
end
