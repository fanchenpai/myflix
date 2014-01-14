require 'spec_helper'

describe VideosController do
  context "with user logged in successfully" do
    before {
      user1 = User.create(full_name: 'test', email:'test@test.com',
                          password: 'test', password_confirmation: 'test')
      session[:user_id] = user1.id
    }
    let (:category1) { Category.create(name: 'Comedy') }
    let (:category2) { Category.create(name: 'Drama') }
    let (:video1) { Video.create(title: 'Video 1', category: category1) }
    let (:video2) { Video.create(title: 'Video 2', category: category1) }

    describe "GET index" do
      before { get :index }
      it "sets the videos variable" do
        expect(assigns(:videos)).to eq [video1, video2]
      end
      it "sets the categories variable" do
        expect(assigns(:categories)).to eq [category1, category2]
      end
      it "renders the index template" do
        expect(response).to render_template :index
      end
    end

    describe "GET show" do
      before { get :show , id: video1.id }
      it "sets the video variable" do
        expect(assigns(:video)).to eq video1
      end
      it "renders the show template" do
        expect(response).to render_template :show
      end
    end

    describe "POST search" do
      before { post :search, search_term: 'video'}
      it "sets the videos variable from input parameters" do
        expect(assigns(:videos)).to eq [video1]
      end
      it "renders the search template" do
        expect(response).to render_template :search
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
