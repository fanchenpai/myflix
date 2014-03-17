require 'spec_helper'

describe InvitationsController do
  describe "GET new" do
    it "sets the invitation variable" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of(Invitation)
    end
    it_behaves_like :require_login do
      let (:action) { get :new }
    end
  end

  describe "POST create" do
    after { ActionMailer::Base.deliveries.clear }
    context "with valid input" do
      before do
        set_current_user
        post :create, invitation: Fabricate.attributes_for(:invitation)
      end
      it "sets the invitation variable" do
        expect(assigns(:invitation)).to be_instance_of(Invitation)
      end
      it "associate current user to the invitation" do
        expect(assigns(:invitation).user_id).to eq current_user.id
      end
      it "generates invitation token" do
        expect(assigns(:invitation).token).not_to be_empty
      end
      it "sends out invitation email" do
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end
      it 'sends to the right recepient' do
        mail = ActionMailer::Base.deliveries.last
        expect(mail.to[0]).to eq Invitation.last.email
      end
      it 'includes the token in email content' do
        mail = ActionMailer::Base.deliveries.last
        expect(mail.body).to include Invitation.last.token
      end
      it 'redirects to the invite page' do
        expect(response).to redirect_to :invite
      end
    end
    context "without valid input" do
      before do
        set_current_user
        post :create, invitation: {full_name: 'test'}
      end
      it "does not create invitation" do
        expect(Invitation.all.count).to be 0
      end
      it "causes error when email field is not filled in" do
        expect(assigns(:invitation).errors).not_to be_empty
      end
      it "does not send out invitation email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
      it "renders the new template" do
        expect(response).to render_template :new
      end
    end
    it_behaves_like :require_login do
      let(:action) { post :create }
    end
  end

end
