require 'spec_helper'

describe QueueItemsController do

  describe 'GET index' do
    before { set_current_user }
    it 'sets the queue_itmes variable' do
      item1 = Fabricate(:queue_item, user: current_user)
      item2 = Fabricate(:queue_item, user: current_user)
      get :index
      expect(assigns(:queue_items)).to match_array [item1, item2]
    end
    it_behaves_like :require_login do
      let(:action) { get :index }
    end
  end

  describe 'POST create' do
    let (:video1) { Fabricate(:video) }
    before { set_current_user }
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
    it_behaves_like :require_login do
      let(:action) { post :create }
    end
  end

  describe 'POST update_queue' do
    before { set_current_user }
    context 'with valid inputs' do
      let (:item1) { Fabricate(:queue_item, user: current_user, position: 1) }
      let (:item2) { Fabricate(:queue_item, user: current_user, position: 2) }
      it 'updates positions for queue items' do
        post :update_queue, queue_items: [{id: item1.id, position: item2.position}, {id: item2.id, position: item1.position}]
        expect(current_user.queue_items.map(&:position)).to eq [1,2]
        expect(current_user.queue_items.map(&:id)).to eq [2,1]
      end
      it 'normalize the position number' do
        post :update_queue, queue_items: [{id: item1.id, position: 5}, {id: item2.id, position: 3}]
        expect(current_user.queue_items.map(&:position)).to eq [1,2]
        expect(current_user.queue_items.map(&:id)).to eq [2,1]
      end
      it 'redirects to my queue page' do
        post :update_queue, queue_items: [{id: item1.id, position: item2.position}, {id: item2.id, position: item1.position}]
        expect(response).to redirect_to :my_queue
      end
      it 'updates the rating of video if a review already exists' do
        review1 = Fabricate(:review, video: item1.video, user: current_user, rating: 5)
        review2 = Fabricate(:review, video: item2.video, user: current_user, rating: 3)
        post :update_queue, queue_items: [{id: item1.id, position: item2.position, rating: 1}, {id: item2.id, position: item1.position, rating: 1}]
        expect(item1.reload.rating).to eq 1
        expect(item2.reload.rating).to eq 1
      end
      it 'creates a review with specified rating if no review was posted yet' do
        review1 = Fabricate(:review, video: item1.video, user: current_user, rating: 5)
        post :update_queue, queue_items: [{id: item1.id, position: item2.position, rating: 1}, {id: item2.id, position: item1.position, rating: 1}]
        expect(Review.count).to eq 2
        expect(item2.reload.rating).to eq 1
      end
      it 'does not change rating if no rating value was passed in' do
        review1 = Fabricate(:review, video: item1.video, user: current_user, rating: 5)
        review2 = Fabricate(:review, video: item2.video, user: current_user, rating: 3)
        post :update_queue, queue_items: [{id: item1.id, position: item2.position, rating: ''}, {id: item2.id, position: item1.position, rating: ''}]
        expect(item1.reload.rating).to eq 5
        expect(item2.reload.rating).to eq 3
      end
    end

    context 'with invalid format inputs' do
      let (:item1) { Fabricate(:queue_item, user: current_user, position: 1) }
      let (:item2) { Fabricate(:queue_item, user: current_user, position: 2) }
      before do
        post :update_queue, queue_items: [{id: item1.id, position: 5.5}, {id: item2.id, position: 'a'}]
      end
      it 'does not update the queue items' do
        expect(item1.reload.position).to eq 1
        expect(item2.reload.position).to eq 2
      end
      it 'sets the flash message' do
        expect(flash[:error]).not_to be_blank
      end
      it 'redirects to my queue page' do
        expect(response).to redirect_to :my_queue
      end
    end

    context 'with queue items that do not belong to current logged in user' do
      let! (:user2) { Fabricate(:user) }
      let! (:item1) { Fabricate(:queue_item, user: user2, position: 1) }
      let! (:item2) { Fabricate(:queue_item, user: current_user, position: 1) }
      let! (:review1) { Fabricate(:review, video: item1.video, user: user2, rating: 5) }
      let! (:review2) { Fabricate(:review, video: item2.video, user: current_user, rating: 3) }
      before do
        post :update_queue, queue_items: [{id: item1.id, position: 5, rating: 1}, {id: item2.id, position: 2, rating: 1}]
      end
      it 'does not update the queue items' do
        expect(item1.reload.position).to eq 1
        expect(item2.reload.position).to eq 1
      end
      it 'does not update the video rating' do
        expect(item1.reload.rating).to eq 5
        expect(item2.reload.rating).to eq 3
      end
      it 'sets the flash message' do
        expect(flash[:error]).not_to be_blank
      end
      it 'redirects to my queue page' do
        expect(response).to redirect_to :my_queue
      end
    end
    it_behaves_like :require_login do
      let(:action) { post :update_queue }
    end
  end

  describe 'GET destroy' do
    before { set_current_user }
    it 'removes the queue item from the queue' do
      queue_item1 = Fabricate(:queue_item, user: current_user)
      delete :destroy, id: queue_item1.id
      expect(QueueItem.count).to eq 0
    end
    it 'normalize the position number' do
      queue_item1 = Fabricate(:queue_item, user: current_user, position: 1)
      queue_item2 = Fabricate(:queue_item, user: current_user, position: 2)
      delete :destroy, id: queue_item1.id
      expect(queue_item2.reload.position).to eq 1
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
    it_behaves_like :require_login do
      let(:action) { delete :destroy, id: 1 }
    end
  end

end
