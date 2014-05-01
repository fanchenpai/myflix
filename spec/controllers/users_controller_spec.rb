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
    context 'when sign up successfully' do
      before do
        result = double('user_sign_up', successful?: true, user_id: 99)
        UserSignUp.any_instance.should_receive(:sign_up).with('abc', nil).and_return(result)
        post :create, { user: Fabricate.attributes_for(:user), stripeToken: 'abc' }
      end
      it 'should set the user variable' do
        expect(assigns(:user)).to be_instance_of(User)
      end
      it 'should log user in automaticaly(session)' do
        expect(session[:user_id]).to eq 99
      end
      it 'should set the flash message' do
        expect(flash[:success]).to be_present
      end
      it 'shoulc redirect to videos page' do
        expect(response).to redirect_to :videos
      end
    end

    context 'when sign up failed without invitation' do
      before do
        result = double('user_sign_up', successful?: false, invitation: nil, error_message: 'error')
        UserSignUp.any_instance.should_receive(:sign_up).with('abc', nil).and_return(result)
        post :create, { user: {full_name: 'test', email: 'test'}, stripeToken: 'abc' }
      end
      it 'should set the user variable' do
        expect(assigns(:user)).to be_present
      end
      it 'should set the flash error message' do
        expect(flash[:error]).to be_present
      end
      it 'should render new template' do
        expect(response).to render_template :new
      end
    end

    context 'when sign up failed with invitation' do
      let(:user1) { Fabricate(:user) }
      let(:invitation) { Fabricate(:invitation, user: user1) }
      before do
        result = double('user_sign_up', successful?: false, invitation: invitation, error_message: 'error')
        UserSignUp.any_instance.should_receive(:sign_up).with('abc', invitation.token).and_return(result)
        post :create, { user: {full_name: 'test', email: 'test'}, stripeToken: 'abc', invitation: invitation.token }
      end
      it 'should set the initation variable' do
        expect(assigns(:invitation)).to be_present
        expect(assigns(:invitation)).to eq invitation
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
