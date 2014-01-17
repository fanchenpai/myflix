require 'spec_helper'

describe QueueItemsController do

  context 'with user logged in successfully' do
    let (:current_user) { Fabricate(:user) }
    before { session[:user_id] = current_user.id }

    describe 'GET index' do
      it 'sets the queue_itmes variable' do
        item1 = Fabricate(:queue_item, user: current_user)
        item2 = Fabricate(:queue_item, user: current_user)
        get :index
        expect(assigns(:queue_items)).to match_array [item1, item2]
      end
    end

  end

  context 'without user logged in' do
    before { session[:user_id] = nil }

    describe 'GET index' do
      it 'redirects to sign in' do
        get :index
        expect(response).to redirect_to :sign_in
      end
    end


  end



end
