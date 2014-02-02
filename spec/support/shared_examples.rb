shared_examples :require_user_login do
  context 'without user logged in' do
    before { clear_current_user }
    it 'redirects to sign in page' do
      action
      expect(response).to redirect_to :sign_in
    end
  end
end
