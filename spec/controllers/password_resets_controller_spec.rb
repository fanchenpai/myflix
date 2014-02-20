require 'spec_helper'

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
    context 'with invalid token' do
      before { get :show, token: 'fake_token' }
      it 'assigns nil to users variable' do
        expect(assigns(:user)).to be_nil
      end
      it 'renders the invalid token page' do
        expect(response).to render_template :invalid_token
      end
    end
    context 'with expired token' do
      let(:user1) { Fabricate(:user)}
      before do
        user1.generate_password_token
        user1.password_token_timestamp = 10.days.ago
        user1.save!(validate: false)
        user1.reload
        get :show, token: user1.password_token
      end
      it 'renders the invalid token page' do
        expect(response).to render_template :invalid_token
      end
      it 'clears user password token in database' do
        expect(User.find(user1.id).password_token).to be_nil
      end
    end
  end

end
