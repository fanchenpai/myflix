require 'spec_helper'

feature 'resetting password' do
  given!(:user1) { Fabricate(:user) }
  scenario 'user goes through password reset process' do
    clear_emails
    visit_forgot_email_page
    fill_in_email
    expect_email_to_be_valid
    visit_password_reset_page_via_email_link
    fill_in_new_password
    expect_password_reset_succeeded
  end

  private

  def visit_forgot_email_page
    visit sign_in_path
    click_on "Forgot Password"
  end
  def fill_in_email
    fill_in('email', with: user1.email)
    click_on('Send Email')
  end
  def expect_email_to_be_valid
    open_email(user1.email)
    expect(page).to have_content "We have send an email"
    expect(current_email).to have_link "reset your password"
    expect(current_email.to[0]).to eq user1.email
    link = current_email.find_link('reset your password')
    expect(link[:href]).to have_content user1.reload.password_token
  end
  def visit_password_reset_page_via_email_link
    current_email.click_link('reset your password')
    expect(page).to have_content "Reset Your Password"
    expect(page).to have_field "New Password"
  end
  def fill_in_new_password
    fill_in('New Password', with: 'new password')
    fill_in('Confirm Password', with: 'new password')
    click_on('Reset Password')
  end
  def expect_password_reset_succeeded
    expect(page).to have_content "Your password has been reset"
    expect(page).to have_field "Email Address"
  end

end
