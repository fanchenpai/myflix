require 'spec_helper'

describe UsersController do
  describe 'GET new' do
    before { get :new }
    it 'sets the users variable' do
      expect(assigns(:user)).to be_new_record
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe 'GET new_via_invitation' do
    let(:invitation1) { Fabricate(:invitation) }
    context 'with valid token' do
      before { get :new_via_invitation, token: invitation1.token }
      it "sets the invitation variable" do
        expect(assigns(:invitation)).to eq invitation1
      end
      it "sets the user variable" do
        expect(assigns(:user)).to be_instance_of(User)
      end
      it "renders the new template" do
        expect(response).to render_template :new
      end
    end
    context 'without valid token' do
      before { get :new_via_invitation, token: "fake_token" }
      it "sets flash error message" do
        expect(flash[:error]).not_to be_empty
      end
      it "redirects to the regular register page" do
        expect(response).to redirect_to :register
      end
    end
  end

  describe 'POST create' do
    context 'when all inputs are valid' do
      before do
        mock_valid_charge
        post :create, { user: Fabricate.attributes_for(:user), stripeToken: 'abc' }
      end
      it 'sets the user variable' do
        expect(assigns(:user)).to be_instance_of(User)
        expect(assigns(:user)).to be_valid
      end
      it 'saves to the db' do
        expect(assigns(:user)).to eq User.last
      end
      it 'sets the session user_id' do
        expect(session[:user_id]).not_to be_nil
        expect(session[:user_id]).to eq User.last.id
      end
      it 'sets flash notice' do
        expect(flash[:success]).not_to be nil
      end
      it 'redirects to videos path' do
        expect(response).to redirect_to videos_path
      end
    end

    context 'when register through invitation and all inputs are valid' do
      let(:user1) { Fabricate(:user) }
      before do
        invitation = Fabricate(:invitation, user_id: user1.id)
        mock_valid_charge
        post :create, {
          user: Fabricate.attributes_for(:user),
          invitation: invitation.token, stripeToken: 'abc' }
      end
      it 'sets the invitation variable' do
        expect(assigns(:invitation)).to eq Invitation.last
      end

      it 'sets the new user to follow inviter' do
        expect(user1.followers).to include User.last
      end
      it 'set the inviter to follow the new user' do
        expect(User.last.followers).to include user1
      end
    end

    context 'when user info inputs are not valid' do
      before do
        ActionMailer::Base.deliveries.clear
        post :create, { user: { full_name: 'test', email: 'test'} }
      end
      it 'set the user variable that marked invalid' do
        expect(assigns(:user)).not_to be_valid
      end
      it 'should not save to db' do
        expect(User.all.size).to eq 0
      end
      it 'renders the new template' do
        expect(response).to render_template :new
      end
      it 'does not send out welcome mail' do
        expect(ActionMailer::Base.deliveries).to be_empty
        ActionMailer::Base.deliveries.clear
      end
    end

    context 'when credit card info is not valid' do
      before do
        ActionMailer::Base.deliveries.clear
        mock_failed_charge
        post :create, { user: Fabricate.attributes_for(:user), stripeToken: 'abc' }
      end
      it 'should not save to db' do
        expect(User.all.size).to eq 0
      end
      it 'renders the new template' do
        expect(response).to render_template :new
      end
      it 'does not send out welcome mail' do
        expect(ActionMailer::Base.deliveries).to be_empty
        ActionMailer::Base.deliveries.clear
      end
      it 'sets the card_error variable' do
        expect(assigns(:card_error)).to be_present
      end
    end

    context "when sending welcome email" do
      before do
        mock_valid_charge
        post :create, {
          user: {
            full_name: 'Alice Wonderland',
            email: 'alice@test.com',
            password: 'password',
            password_confirmation: 'password'
          }, stripeToken: 'abc'
        }
      end
      after { ActionMailer::Base.deliveries.clear }
      it 'sends out the email' do
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end
      it 'sends to the right recepient' do
        expect(ActionMailer::Base.deliveries.last.to[0]).to eq 'alice@test.com'
      end
      it 'has the correct message content' do
        expect(ActionMailer::Base.deliveries.last.body).to include 'Alice Wonderland'
      end
    end
  end

  describe 'GET show' do
    let(:user1) { Fabricate(:user) }
    before { set_current_user }
    it 'sets the user variable' do
      get :show, id: user1.id
      expect(assigns(:user)).to eq user1
    end
    it_behaves_like :require_login do
      let(:action) { get :show, id: user1.id }
    end
  end

end
