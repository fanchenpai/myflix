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

    describe 'POST create' do
      let (:video1) { Fabricate(:video) }
      it 'creates a queue item' do
        post :create, video_id: video1.id
        expect(QueueItem.count).to eq 1
      end
      it 'creates queue item that associates to the video' do
        post :create, video_id: video1.id
        expect(QueueItem.first.video).to eq video1
      end
      it 'creates queue itme that associates to the logged in user' do
        post :create, video_id: video1.id
        expect(QueueItem.first.user).to eq current_user
      end
      it 'does not add the same video to the queue twice' do
        Fabricate(:queue_item, video: video1, user: current_user)
        post :create, video_id: video1.id
        expect(current_user.queue_items.count).to eq 1
        expect(flash[:error]).not_to be_blank
      end
      it 'puts the newly created queue item at the last position' do
        video2 = Fabricate(:video)
        Fabricate(:queue_item, video: video2, user: current_user, position: 1)
        post :create, video_id: video1.id
        expect(QueueItem.last.position).to be > QueueItem.first.position
        expect(current_user.queue_items.maximum(:position)).to eq QueueItem.last.position
      end
      it 'redirects to my queue page' do
        post :create, video_id: video1.id
        expect(response).to redirect_to :my_queue
      end
      it 'sets a flash message' do
        post :create, video_id: video1.id
        expect(flash[:notice]).not_to be_blank
      end
    end

    describe 'POST bulk_update' do
      # "queue_items"=>[{"id"=>"1", "position"=>"5"}, {"id"=>"3", "position"=>"3"}, {"id"=>"4", "position"=>"4"}]
      it 'updates position for each queue items' do
        item1 = Fabricate(:queue_item, user: current_user, position: 1)
        item2 = Fabricate(:queue_item, user: current_user, position: 2)
        post :bulk_update, "queue_items"=>[{"id"=>"#{item1.id}", "position"=>"#{item2.position}"}, {"id"=>"#{item2.id}", "position"=>"#{item1.position}"}]
        expect(item1.reload.position).to eq 2
        expect(item2.reload.position).to eq 1
      end
    end

    describe 'GET destroy' do
      it 'removes the queue item from the queue' do
        queue_item1 = Fabricate(:queue_item, user: current_user)
        delete :destroy, id: queue_item1.id
        expect(QueueItem.count).to eq 0
      end
      it 'redirects back to my queue page' do
        queue_item1 = Fabricate(:queue_item)
        delete :destroy, id: queue_item1.id
        expect(response).to redirect_to :my_queue
      end
      it 'does not remove queue item that belongs to other user' do
        user2 = Fabricate(:user)
        queue_item2 = Fabricate(:queue_item, user: user2)
        delete :destroy, id: queue_item2.id
        expect(QueueItem.count).to eq 1
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

    describe 'POST create' do
      it 'redirects to sign in' do
        post :create
        expect(response).to redirect_to :sign_in
      end
    end

    describe 'DELETE destroy' do
      it 'redirects to sign in' do
        delete :destroy, id: 1
        expect(response).to redirect_to :sign_in
      end
    end
  end

end
