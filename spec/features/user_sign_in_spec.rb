require 'spec_helper'

feature "Signing in" do
  given(:user1) { Fabricate(:user) }

  scenario "Signing in with correct credentials" do
    user_sign_in(user1)
    expect(page).to have_content user1.full_name
  end

  scenario "Signing in with incorrect credentials" do
    visit sign_in_path
    within("#new_user") do
      fill_in 'user[email]', with: user1.email
      fill_in 'user[password]', with: 'fake password'
    end
    click_button 'Sign In'
    expect(page).to have_content 'something wrong with your email/password'
  end
end
