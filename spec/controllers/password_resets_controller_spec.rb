require 'spec_helper'

shared_examples :require_valid_token do
  context 'with invalid token' do
    before { action}
    it 'assigns nil to users variable' do
      expect(assigns(:user)).to be_nil
    end
    it 'renders the invalid token page' do
      expect(response).to render_template :invalid_token
    end
  end
end

shared_examples :require_fresh_token do
  context 'with expired token' do
    let(:user1) { Fabricate(:user)}
    let(:token) { user1.token }
    before do
      user1.update_attribute('token_timestamp', 10.days.ago)
      action
    end
    it 'renders the invalid token page' do
      expect(response).to render_template :invalid_token
    end
    it 'clears user password token in database' do
      expect(User.find(user1.id).token).to be_nil
    end
  end
end

describe PasswordResetsController do
  describe 'POST create' do
    after { ActionMailer::Base.deliveries.clear }
    context 'with existing email input' do
      let! (:user1) { Fabricate(:user) }
      before { post :create, email: user1.email }

      it 'sets the user variable' do
        expect(assigns(:user)).to eq user1
      end
      it 'generates a token' do
        expect(assigns(:user).token).not_to be_empty
      end
      it 'sends out password reset email' do
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end
      it 'sends to the right recepient' do
        mail = ActionMailer::Base.deliveries.last
        expect(mail.to[0]).to eq user1.email
      end
      it 'includes the token in email content' do
        mail = ActionMailer::Base.deliveries.last
        expect(mail.body).to include user1.reload.token
      end
      it 'includes the password reset link in email content' do
        mail = ActionMailer::Base.deliveries.last
        expect(mail.body).to include reset_password_path(user1.reload.token)
      end
    end
    context 'with non-existing email input' do
      before do
        ActionMailer::Base.deliveries.clear
        real_user = Fabricate(:user)
        post :create, email: 'fake@test.com'
      end

      it 'assigns nil to user variable' do
        expect(assigns(:user)).to be_nil
      end
      it 'does send out password reset email' do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
      it 'sets flash message' do
        expect(flash[:error]).not_to be_empty
      end
      it 'redirects to forgot password page' do
        expect(response).to redirect_to :forgot_password
      end
    end
  end

  describe 'GET show' do
    context 'with valid token' do
      it 'sets the user variable' do
        user1 = Fabricate(:user, token: '12345', token_timestamp: Time.now)
        get :show, token: user1.token
        expect(assigns(:user)).to eq user1
      end
    end
    it_behaves_like :require_valid_token do
      let (:action) { get :show, token: 'fake_token'}
    end
    it_behaves_like :require_fresh_token do
      let (:action) { get :show, token: token }
    end
  end

  describe 'POST update' do
    context 'with valid token' do
      context 'with valid input' do
        let(:user1) { Fabricate(:user, token: '12345', token_timestamp: Time.now) }
        before do
          post :update, {
            token: user1.token,
            user: {
              password: 'new_password',
              password_confirmation: 'new_password'
            }
          }
        end
        it 'sets the user variable' do
          expect(assigns(:user)).to eq user1
        end
        it 'updates user password' do
          expect(User.find(user1.id).authenticate('new_password')).to be_true
        end
        it 'clears user password token' do
          expect(User.find(user1.id).token).to be_nil
        end
        it 'sets flash notice' do
          expect(flash[:success]).not_to be_nil
        end
        it 'redirects to sign in page' do
          expect(response).to redirect_to :sign_in
        end
      end
      context 'with invalid input' do
        let(:user1) { Fabricate(:user, token: '12345', token_timestamp: Time.now) }
        it 'renders the reset password form' do
          post :update, {
            token: user1.token,
            user: {
              password: '123',
              password_confirmation: '456'
            }
          }
          expect(response).to render_template :show
        end
      end
    end
    it_behaves_like :require_valid_token do
      let (:action) { post :update, { token: 'fake_token' } }
    end
    it_behaves_like :require_fresh_token do
      let (:action) do
        post :update, {
          token: token,
          user: { password: '123', password_confirmation: '123' }
        }
      end
    end
  end

end
