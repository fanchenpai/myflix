require 'spec_helper'

describe Admin::VideosController do

  describe "GET new" do
    it_behaves_like :require_login do
      let(:action) { get :new }
    end
    it_behaves_like :require_admin do
      let(:action) { get :new }
    end
    it "sets the video variable" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_instance_of Video
      expect(assigns(:video)).to be_new_record
    end

  end

end
