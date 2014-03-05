class UserMailer < ActionMailer::Base
  default from: "service@myflix.com"

  def welcome_email(user_id)
    @user = User.find(user_id)
    @url = sign_in_url
    mail(to: @user.email,
         subject: 'Welcome to MyFLiX site!')
  end

  def password_reset_email(user_id)
    user = User.find(user_id)
    @token = user.token
    mail(to: user.email,
         subject: 'Reset your password')
  end

  def invitation_email(invitation_id)
    @invitation = Invitation.find(invitation_id)
    @user = @invitation.user
    mail(to: @invitation.email,
         subject: "#{@user.full_name} invites you to join MyFLiX!!")
  end
end
