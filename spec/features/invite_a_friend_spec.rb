require 'spec_helper'

feature 'inviting a friend' do
  let(:user1) { Fabricate(:user) }
  before { clear_emails }

  scenario 'user invite a friend and then friend register' do
    inviter_fill_in_invitation
    invitee_register_with_invitation
    expect_them_following_each_other
  end

  private

  def inviter_fill_in_invitation
    user_sign_in(user1)
    click_on "Invite a friend"
    fill_out_invitation
    expect_valid_invitation_be_sent
    click_on "Sign Out"
  end

  def invitee_register_with_invitation
    current_email.click_link('Join MyFLiX')
    expect(page).to have_content 'Register'
    expect_name_and_email_prefilled
    submit_register_form
    expect_account_be_created_and_logged_in
    expect_welcome_email_be_sent
  end

  def fill_out_invitation
    fill_in('invitation[full_name]', with: 'Alice Wonderland')
    fill_in('invitation[email]', with: 'alice@test.com')
    click_on('Send Invitation')
  end

  def expect_valid_invitation_be_sent
    expect(page).to have_content('Your invitations has been sent')
    open_email('alice@test.com')
    expect(current_email).to have_content "invites you to join"
    expect(current_email).to have_link "Join MyFLiX"
    expect(current_email.to[0]).to eq 'alice@test.com'
    link = current_email.find_link('Join MyFLiX')
    invitation = Invitation.last
    expect(link[:href]).to have_content invitation.token
  end

  def expect_name_and_email_prefilled
    expect(find_field('user[full_name]').value).to eq 'Alice Wonderland'
    expect(find_field('user[email]').value).to eq 'alice@test.com'
  end

  def submit_register_form
    fill_in('user[password]', with: 'password')
    fill_in('user[password_confirmation]', with: 'password')
    click_on('Sign Up')
  end

  def expect_account_be_created_and_logged_in
    expect(page).to have_content 'Your account has been created'
    expect(page).to have_content 'Welcome, Alice Wonderland'
  end

  def expect_welcome_email_be_sent
    open_email('alice@test.com')
    expect(current_email).to have_content 'Welcome to MyFLiX.com, Alice Wonderland'
    expect(current_email).to have_link "Sign in to MyFLiX"
    expect(current_email.to[0]).to eq 'alice@test.com'
  end

  def expect_them_following_each_other
    click_on "People"
    expect(page).to have_link(user1.full_name)
    click_on "Sign Out"
    user_sign_in(user1)
    click_on "People"
    expect(page).to have_link("Alice Wonderland")
  end
end
