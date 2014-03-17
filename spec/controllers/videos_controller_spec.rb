require 'spec_helper'

describe VideosController do

  describe "GET index" do
    let (:video1) { Fabricate(:video) }
    let (:video2) { Fabricate(:video) }
    before { set_current_user }
    it "sets the videos variable" do
      get :index
      expect(assigns(:videos)).to eq [video1, video2]
    end
    it "sets the categories variable" do
      get :index
      expect(assigns(:categories)).to match_array [video1.category, video2.category]
    end
    it_behaves_like :require_login do
      let(:action)  { get :index }
    end
  end

  describe "GET show" do
    let (:video1) { Fabricate(:video) }
    before { set_current_user }
    it "sets the video variable" do
      get :show , id: video1.id
      expect(assigns(:video)).to eq video1
    end
    it "has reviews associated with the the video" do
      review1 = Fabricate(:review, video: video1)
      review2 = Fabricate(:review, video: video1)
      get :show , id: video1.id
      expect(assigns(:video).reviews).to match_array [review1, review2]
    end
    it "sets the review variable" do
      get :show , id: video1.id
      expect(assigns(:review)).to be_new_record
      expect(assigns(:review)).to be_instance_of(Review)
    end
    it_behaves_like :require_login do
      let(:action)  { get :show , id: video1.id }
    end
  end

  describe "POST search" do
    let (:video1) { Fabricate(:video) }
    before { set_current_user }
    it "sets the videos variable from input parameters" do
      post :search, search_term: video1.title[0..3]
      expect(assigns(:videos)).to eq [video1]
    end
    it_behaves_like :require_login do
      let(:action)  { post :search, search_term: video1.title[0..3] }
    end
  end

  describe "GET index_by_category" do
    let (:video1) { Fabricate(:video) }
    before { set_current_user }
    it "sets the category variable" do
      get :index_by_category, id: video1.category.id
      expect(assigns(:category)).to eq video1.category
    end
    it "renders the genre template" do
      get :index_by_category, id: video1.category.id
      expect(response).to render_template :genre
    end
    it_behaves_like :require_login do
      let(:action)  { get :index_by_category, id: video1.category.id }
    end
  end

end
