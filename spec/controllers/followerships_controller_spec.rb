require 'spec_helper'

describe FollowershipsController do
  describe 'GET index' do
    before { set_current_user }
    it_behaves_like :require_login do
      let(:action) { get :index }
    end
    it 'sets leaderships variable' do
      get :index
      expect(assigns(:leaderships)).to eq current_user.leaderships
    end
  end

  describe 'POST create' do
    let!(:user2) { Fabricate(:user) }
    before do
      set_current_user
      post :create, following: user2.id
    end
    it_behaves_like :require_login do
      let(:action) { post :create, following: 2}
    end
    it 'associates the people being followed to current user' do
      expect(user2.followers).to include(current_user)
    end
    it 'saves the followership to db' do
      expect(Followership.count).to eq 1
    end
    it 'does not create the same followership twice' do
      post :create, following: user2.id
      expect(Followership.count).to eq 1
    end
    it 'does not allow one to follow self' do
      post :create, following: current_user.id
      expect(Followership.count).to eq 1
    end
    it 'sets flash notice' do
      expect(flash[:notice]).not_to be_blank
    end
    it 'redirects to user show page' do
      expect(response).to redirect_to user_path(user2)
    end
  end

  describe 'DELETE destroy' do
    let!(:user2) { Fabricate(:user) }
    before { set_current_user }
    it_behaves_like :require_login do
      let(:action) { delete :destroy, id: 1 }
    end
    it 'delete the associated following relationship from current user' do
      followership1 = Fabricate(:followership, user_id: user2.id, follower_id: current_user.id)
      delete :destroy, id: followership1.id
      expect(Followership.all.count).to be 0
    end
    it 'does not delete the relation if current user is not a follower' do
      user3 = Fabricate(:user)
      followership1 = Fabricate(:followership, user_id: user2.id, follower_id: user3.id)
      delete :destroy, id: followership1.id
      expect(Followership.all.count).to be 1
    end
    it 'redirects to followership index page (PEOPLE)' do
      followership1 = Fabricate(:followership, user_id: user2.id, follower_id: current_user.id)
      delete :destroy, id: followership1.id
      expect(response).to redirect_to followerships_path
    end
  end
end
