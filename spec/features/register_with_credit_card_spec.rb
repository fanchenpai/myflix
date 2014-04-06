require 'spec_helper'

feature 'register with credit card', {js: true, vcr: true} do
  given(:valid_card_number) { '4242424242424242' }
  given(:incorrect_card_number) { '4242424242424241' }
  given(:failed_cvc_card_number) { '4000000000000127' }
  given(:declined_card_number) { '4000000000000002' }
  given(:expired_card_number) { '4000000000000069' }
  given(:process_error_card_number) { '4000000000000119' }

  scenario 'with valid user info and credit card' do
    visit register_path
    fill_in_valid_user_info
    fill_in_credit_card_info(valid_card_number)
    click_on('Sign Up')
    expect_account_be_created_and_logged_in
    expect_welcome_email_be_sent
  end

  scenario 'with valid user info but invalid credit card number' do
    visit register_path
    fill_in_valid_user_info
    fill_in_credit_card_info(failed_cvc_card_number)
    click_on('Sign Up')
    expect(page).to have_content 'security code is incorrect'
    fill_in_valid_user_info
    fill_in_credit_card_info(expired_card_number)
    click_on('Sign Up')
    expect(page).to have_content 'expiration date is incorrect'
    fill_in_valid_user_info
    fill_in_credit_card_info(incorrect_card_number)
    click_on('Sign Up')
    expect(page).to have_content 'card number is incorrect'
    fill_in_valid_user_info
    fill_in_credit_card_info(process_error_card_number)
    click_on('Sign Up')
    expect(page).to have_content 'error occurred while processing your card'
  end

  scenario 'with valid user info but declined credit card' do
    visit register_path
    fill_in_valid_user_info
    fill_in_credit_card_info(declined_card_number)
    click_on('Sign Up')
    expect(page).to have_content 'card was declined'
  end

  scenario 'with invalid user info but valid credit card' do
    visit register_path
    fill_in('user[email]', with: 'alice@test.com')
    fill_in_credit_card_info(valid_card_number)
    click_on('Sign Up')
    expect(page).to have_content "can't be blank"
    expect(page).to have_content 'correct the highlighted field'
    fill_in_invalid_user_info
    fill_in_credit_card_info(valid_card_number)
    expect(page).to have_content 'correct the highlighted field'
  end

  scenario 'with invalid user info and invalid credit card number' do
    visit register_path
    click_on('Sign Up')
    expect(page).to have_content 'card number looks invalid'
    fill_in('user[email]', with: 'alice@test.com')
    fill_in_credit_card_info(incorrect_card_number)
    click_on('Sign Up')
    expect(page).to have_content 'card number is incorrect'
  end

  scenario 'with invalid user info and declined credit card' do
    visit register_path
    fill_in('user[email]', with: 'alice@test.com')
    fill_in_credit_card_info(declined_card_number)
    click_on('Sign Up')
    expect(page).to have_content 'correct the highlighted field'
  end

  def fill_in_credit_card_info(number, cvc='123')
    fill_in('Credit Card Number', with: number)
    fill_in('Security Code', with: cvc)
    select('5 - May', from: 'date_month')
    select((Date.today.year+1).to_s, from: 'date_year')
  end

  def fill_in_valid_user_info
    fill_in('user[full_name]', with: 'Alice Wonderland')
    fill_in('user[email]', with: 'alice@test.com')
    fill_in('user[password]', with: 'password')
    fill_in('user[password_confirmation]', with: 'password')
  end

  def fill_in_invalid_user_info
    fill_in('user[full_name]', with: 'Alice Wonderland')
    fill_in('user[email]', with: 'alice@test.com')
    fill_in('user[password]', with: 'password')
    fill_in('user[password_confirmation]', with: 'another')
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

end
