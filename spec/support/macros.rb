def set_current_user
  user1 = Fabricate(:user)
  session[:user_id] = user1.id
end

def set_current_admin
  user1 = Fabricate(:admin)
  session[:user_id] = user1.id
end

def current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end

def sign_in(user=nil)
  user1 = user || Fabricate(:user)
  visit sign_in_path
  within("#new_user") do
    fill_in 'user[email]', with: user1.email
    fill_in 'user[password]', with: user1.password
  end
  click_on 'Sign In'
end

def sign_out
  visit sign_out_path
end

def mock_valid_charge
  charge = double(:charge, successful?: true)
  StripeWrapper::Charge.should_receive(:create).and_return(charge)
end

def mock_failed_charge
  charge = double(:charge, successful?: false, error_message: 'declined')
  StripeWrapper::Charge.should_receive(:create).and_return(charge)
end
