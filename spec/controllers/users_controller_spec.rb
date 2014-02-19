require 'spec_helper'

describe UsersController do
  describe 'GET new' do
    before { get :new }
    it 'sets the users variable' do
      expect(assigns(:user)).to be_new_record
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe 'POST create' do
    context 'when inputs are valid and saved to db' do
      before { post :create, { user: Fabricate.attributes_for(:user) } }
      it 'sets the user variable' do
        expect(assigns(:user)).to be_instance_of(User)
        expect(assigns(:user)).to be_valid
      end
      it 'saves to the db' do
        expect(assigns(:user)).to eq User.first
      end
      it 'sets the session user_id' do
        expect(session[:user_id]).not_to be_nil
        expect(session[:user_id]).to eq User.first.id
      end
      it 'sets flash notice' do
        expect(flash[:success]).not_to be nil
      end
      it 'redirects to videos path' do
        expect(response).to redirect_to videos_path
      end
    end

    context 'when inputs are not valid' do
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

    context "when sending welcome email" do
      before do
        post :create, {
          user: {
            full_name: 'Alice Wonderland',
            email: 'alice@test.com',
            password: 'password',
            password_confirmation: 'password'
          }
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
    it_behaves_like :require_user_login do
      let(:action) { get :show, id: user1.id }
    end
  end

end
