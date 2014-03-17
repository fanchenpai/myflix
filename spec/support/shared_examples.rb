shared_examples :require_login do
  context 'without user logged in' do
    before { clear_current_user }
    it 'redirects to sign in page' do
      action
      expect(response).to redirect_to :sign_in
    end
  end
end

shared_examples :require_admin do
  context 'user is not admin' do
    before do
      set_current_user
      action
    end
    it 'redirect_to the root page' do
      expect(response).to redirect_to :root
    end
    it 'sets flash error message' do
      expect(flash[:error]).to be_present
    end
  end

end

shared_examples :tokenable do
  context 'with #generate_token before create' do
    it 'sets the token and token_timestamp' do
      expect(object.token).not_to be_nil
      expect(object.token_timestamp).not_to be_nil
    end
  end

  context 'when clear_token' do
    it 'clears the password token and token timestamp' do
      object.clear_token
      object.reload
      expect(object.token).to be_nil
      expect(object.token_timestamp).to be_nil
    end
  end

  context 'when check if token expired' do
    let(:token_life_span) { 1.day }
    it 'returns true if token expired' do
      object.update_attribute('token_timestamp', 2.days.ago)
      expect(object.token_expired?(token_life_span)).to be_true
    end
    it 'returns false if token is not expired' do
      object.update_attribute('token_timestamp', Time.now)
      expect(object.token_expired?(token_life_span)).to be_false
    end
  end

end
