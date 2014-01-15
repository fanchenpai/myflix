require 'spec_helper'

describe 'Routing' do
  it { should route(:get, '/genre/1').to('videos#index_by_category', id: '1') }
end

describe VideosController do
  context "with user logged in successfully" do
    before { session[:user_id] = Fabricate(:user).id }

    let (:video1) { Fabricate(:video) }
    let (:video2) { Fabricate(:video) }

    describe "GET index" do
      before { get :index }
      it "sets the videos variable" do
        expect(assigns(:videos)).to eq [video1, video2]
      end
      it "sets the categories variable" do
        expect(assigns(:categories)).to eq [video1.category, video2.category]
      end
    end

    describe "GET show" do
      before { get :show , id: video1.id }
      it "sets the video variable" do
        expect(assigns(:video)).to eq video1
      end
      it "has reviews associated with the the video" do
        review1 = Fabricate(:review, video: video1)
        review2 = Fabricate(:review, video: video1)
        expect(assigns(:video).reviews).to match_array [review1, review2]
      end
      it "sets the review variable" do
        expect(assigns(:review)).to be_new_record
        expect(assigns(:review)).to be_instance_of(Review)
      end
    end

    describe "POST search" do
      before { post :search, search_term: video1.title[0..3]}
      it "sets the videos variable from input parameters" do
        expect(assigns(:videos)).to eq [video1]
      end
    end

    describe "GET index_by_category" do
      before { get :index_by_category, id: video1.category.id }
      it "sets the category variable" do
        expect(assigns(:category)).to eq video1.category
      end
      it "renders the genre template" do
        expect(response).to render_template :genre
      end
    end
  end

  context "without user logged in" do
    describe "GET index" do
      it "redirect to sign in" do
        get :index
        expect(response).to redirect_to :sign_in
      end
    end
    describe "GET show" do
      it "redirect to sign in" do
        get :index
        expect(response).to redirect_to :sign_in
      end
    end

    describe "POST search" do
      it "redirect to sign in" do
        get :index
        expect(response).to redirect_to :sign_in
      end
    end
  end

end
