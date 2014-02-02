require 'spec_helper'

describe SessionsController do

  describe 'GET new' do
    it 'redirect to videos page if already logged in' do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to videos_path
    end
    it 'sets the user variable' do
      session[:user_id] = nil
      get :new
      expect(assigns(:user)).to be_new_record
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe 'POST create' do
    let (:user1) { Fabricate(:user) }
    context 'when inputs are valid' do
      before { post :create, { user: { email: user1.email, password: user1.password } } }
      it 'sets the user id in session' do
        expect(session[:user_id]).to eq user1.id
      end
      it 'sets the flash notice' do
        expect(flash[:success]).not_to be_blank
      end
      it 'redirets to videos page' do
        expect(response).to redirect_to videos_path
      end
    end
    context 'when inputs are not valid' do
      before {post :create, { user: { email: user1.email, password: user1.password+'xxx' } } }
      it 'sets the flash error' do
        expect(flash[:error]).not_to be_blank
      end
      it 'redirects to sign in page' do
        expect(response).to redirect_to sign_in_path
      end
    end

  end

  describe 'GET destroy' do
    before do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end
    it 'sets flash notice' do
      expect(flash[:notice]).not_to be_blank
    end
    it 'clears user id in session' do
      expect(session[:user_id]).to be_nil
    end
    it 'redirects to root page' do
      expect(response).to redirect_to root_path
    end
  end

end
