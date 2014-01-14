require 'spec_helper'

# describe 'Routing' do
#   # it { should route(:get, '/posts').to(controller: 'posts', action: 'index') }
#   # it { should route(:get, '/posts/1').to('posts#show', id: 1) }
# end
describe UsersController do
  describe 'GET new' do
    before { get :new }
    it 'sets the users variable' do
      expect(assigns(:user)).to be_new_record
    end

    it 'renders the new template' do
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do
    context 'when inputs are valid and saved to db' do
      before do
        post :create, { user: { full_name: 'test', email: 'test@test.com',
                                password: 'test', password_confirmation: 'test'} }
      end

      it 'sets the user variable' do
        expect(assigns(:user)).to be_valid
      end
      it 'saves to the db' do
        expect(assigns(:user)).to eq User.first
      end
      it 'sets the session user_id' do
        expect(session[:user_id]).not_to be_nil
        expect(session[:user_id]).to eq User.first.id
      end
      it 'sets flash notice' do
        expect(flash[:success]).not_to be nil
      end
      it 'redirects to videos path' do
        expect(response).to redirect_to videos_path
      end
    end

    context 'when inputs are not valid' do
      before do
        post :create, { user: { full_name: 'test', email: 'test'} }
      end
      it 'set the user variable that marked invalid' do
        expect(assigns(:user)).not_to be_valid
      end
      it 'should not save to db' do
        expect(User.all.size).to eq 0
      end
      it 'renders the new template' do
        expect(response).to render_template :new
        #[deprecated] I18n.enforce_available_locales will default to true in the future. If you really want to skip validation of your locale you can set I18n.enforce_available_locales = false to avoid this message.
      end
    end
  end

end
