def set_current_user(admin=nil)
  user1 = Fabricate(:user, admin: admin)
  session[:user_id] = user1.id
end

def set_current_admin
  set_current_user(true)
end

def current_user
  User.find(session[:user_id])
end


def clear_current_user
  session[:user_id] = nil
end

def user_sign_in(user=nil)
  user1 = user || Fabricate(:user)
  visit sign_in_path
  within("#new_user") do
    fill_in 'user[email]', with: user1.email
    fill_in 'user[password]', with: user1.password
  end
  click_button 'Sign In'
end
