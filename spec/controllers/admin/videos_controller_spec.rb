require 'spec_helper'

describe Admin::VideosController do

  describe "GET new" do
    let(:action) { get :new }
    it_behaves_like :require_login
    it_behaves_like :require_admin
    it "sets the video variable" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_instance_of Video
      expect(assigns(:video)).to be_new_record
    end
  end

  describe "POST create" do
    let(:action) { post :create }
    it_behaves_like :require_login
    it_behaves_like :require_admin
    context "with valid input" do
      before do
        set_current_admin
        post :create, video: Fabricate.attributes_for(:video)
      end
      it "redirects to admin video index page" do
        expect(response).to redirect_to :admin_videos
      end
      it "saves a video to db" do
        expect(Video.all.count).to eq 1
      end
      it "sets the flash notice message" do
        expect(flash[:notice]).to be_present
      end
    end
    context "with invalid input" do
      before do
        set_current_admin
        post :create, video: {description: 'test'}
      end
      it "sets the video variable" do
        expect(assigns(:video)).to be_present
      end
      it "does not save to db" do
        expect(Video.all.count).to eq 0
      end
      it "renders the new template" do
        expect(response).to render_template :new
      end
    end
  end

  describe "GET index" do
    let(:action) { get :index }
    it_behaves_like :require_login
    it_behaves_like :require_admin
    it "sets the videos variable" do
      v1 = Fabricate(:video)
      v2 = Fabricate(:video)
      set_current_admin
      get :index
      expect(assigns(:videos)).to match_array Video.all
    end

  end

end
