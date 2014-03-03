require 'spec_helper'

describe Invitation do
  it { should belong_to :user}
  it { should validate_presence_of :email }
  it { should validate_presence_of :user_id }


  describe '#fulfilled(user)' do
    it 'clears token' do
      inviter = Fabricate(:user)
      invitee = Fabricate(:user)
      invitation1 = Fabricate(:invitation, user_id: inviter.id)
      invitation1.fulfilled(invitee)
      expect(Invitation.last.token).to be_nil
      expect(Invitation.last.token_timestamp).to be_nil
    end
    it "record the invitee's user id" do
      inviter = Fabricate(:user)
      invitee = Fabricate(:user)
      invitation1 = Fabricate(:invitation, user_id: inviter.id)
      invitation1.fulfilled(invitee)
      expect(Invitation.last.new_user_id).to eq invitee.id
    end
  end

  it_behaves_like :tokenable do
    let(:object) { Fabricate(:invitation) }
  end

end
