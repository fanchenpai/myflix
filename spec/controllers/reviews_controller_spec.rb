require 'spec_helper'

describe ReviewsController do
  let (:video1) { Fabricate(:video) }
  let (:current_user) { Fabricate(:user) }

  context 'when user has logged in' do
    before { session[:user_id] = current_user.id }
    describe 'POST create' do
      context 'with valid input' do
        before { post :create, review: Fabricate.attributes_for(:review), video_id: video1.id, user_id: current_user.id }
        it 'sets the video variable' do
          expect(assigns(:video)).to eq video1
        end
        it 'sets the review variable' do
          expect(assigns(:review)).to be_instance_of(Review)
        end
        it 'associate the review to current user' do
          expect(assigns(:review).user).to eq current_user
        end
        it 'associate the review to current video' do
          expect(assigns(:review).video).to eq video1
        end
        it 'saves the review to db' do
          expect(assigns(:review)).to be_valid
          expect(Review.all.count).to eq 1
        end
        it 'sets the flash notice' do
          expect(flash[:notice]).not_to be_blank
        end
        it 'redirects to video show page' do
          expect(response).to redirect_to video_path(video1)
        end

      end
      context 'with invalid input' do
        before { post :create, review: {title: 'test'}, video_id: video1.id, user_id: current_user.id }
        it 'does not save the review' do
          expect(assigns(:review)).not_to be_valid
          expect(Review.all.count).to eq 0
        end
        it 'reloads the reviews array associated with the video' do
          expect(assigns(:video).reviews.count).to eq 0
        end
        it 'renders the video show page' do
          expect(response).to render_template 'videos/show'
        end
      end
    end
  end

  context 'when user has not logged in' do
    describe 'POST create' do
      it 'redirects to sign in page' do
        session[:user_id] = nil

        post :create, review: Fabricate.attributes_for(:review), video_id: video1.id
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end
