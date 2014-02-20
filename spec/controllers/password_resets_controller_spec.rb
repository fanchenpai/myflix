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
    let(:token) { user1.password_token }
    before do
      user1.generate_password_token
      user1.update_attribute(:password_token_timestamp, 10.days.ago)
      user1.reload
      action
    end
    it 'renders the invalid token page' do
      expect(response).to render_template :invalid_token
    end
    it 'clears user password token in database' do
      expect(User.find(user1.id).password_token).to be_nil
    end
  end
end

describe PasswordResetsController do
  describe 'POST create' do
    after { ActionMailer::Base.deliveries.clear }
    context 'with valid input' do
      let! (:user1) { Fabricate(:user) }
      before { post :create, email: user1.email }

      it 'sets the user variable' do
        expect(assigns(:user)).to eq user1
      end
      it 'generates a token' do
        expect(assigns(:user).password_token).not_to be_empty
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
        expect(mail.body).to include user1.reload.password_token
      end
      it 'includes the password reset link in email content' do
        mail = ActionMailer::Base.deliveries.last
        expect(mail.body).to include reset_password_path(user1.reload.password_token)
      end
    end
    context 'with invalid input' do
      before do
        real_user = Fabricate(:user)
        post :create, email: 'fake@test.com'
      end

      it 'assigns nil to user variable' do
        expect(assigns(:user)).to be_nil
      end
      it 'does send out password reset email' do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe 'GET show' do
    context 'with valid token' do
      it 'sets the user variable' do
        user1 = Fabricate(:user)
        user1.generate_password_token
        user1.reload
        get :show, token: user1.password_token
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
        let(:user1) { Fabricate(:user) }
        before do
          user1.generate_password_token
          user1.reload
          post :update, {
            token: user1.password_token,
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
          expect(User.find(user1.id).password_token).to be_nil
        end
        it 'sets flash notice' do
          expect(flash[:notice]).not_to be_nil
        end
        it 'redirects to sign in page' do
          expect(response).to redirect_to :sign_in
        end
      end
      context 'with invalid input' do
        it 'renders the reset password form' do
          user1 = Fabricate(:user)
          user1.generate_password_token
          user1.reload
          post :update, {
            token: user1.password_token,
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
