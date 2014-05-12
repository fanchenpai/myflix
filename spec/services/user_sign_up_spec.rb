require 'spec_helper'

describe UserSignUp do

  describe '#sign_up' do

    after { ActionMailer::Base.deliveries.clear }

    context 'when all inputs are valid' do
      let(:user) { Fabricate.build(:user) }
      let(:user_sign_up) { UserSignUp.new(user) }
      before { mock_valid_charge }
      it 'returns UserSignUp object' do
        result = user_sign_up.sign_up('abc')
        expect(result).to be_instance_of(UserSignUp)
      end
      it 'should be successful' do
        result = user_sign_up.sign_up('abc')
        expect(result).to be_successful
      end
      it 'should save the user to database' do
        result = user_sign_up.sign_up('abc')
        expect(User.all.count).to eq 1
      end
    end

    context 'when register through invitation and all inputs are valid' do
      let(:user1) { Fabricate(:user) }
      let(:invitation) { Fabricate(:invitation, user_id: user1.id) }
      let(:user2) { Fabricate.build(:user)}
      let(:user_sign_up) { UserSignUp.new(user2) }
      before { mock_valid_charge }
      it 'should be successful' do
        result = user_sign_up.sign_up('abc', invitation.token)
        expect(result).to be_successful
      end
      it 'sets the new user to follow inviter' do
        result = user_sign_up.sign_up('abc', invitation.token)
        expect(user1.followers).to include User.last
      end
      it 'set the inviter to follow the new user' do
        result = user_sign_up.sign_up('abc', invitation.token)
        expect(User.last.followers).to include user1
      end
      it 'clears the invitation token' do
        result = user_sign_up.sign_up('abc', invitation.token)
        expect(invitation.reload.token).to be_nil
      end
    end

    context 'when user info inputs are not valid' do
      let(:user) { Fabricate.build(:user, password: nil) }
      let(:user_sign_up) { UserSignUp.new(user) }
      it 'should not save to db' do
        result = user_sign_up.sign_up('abc')
        expect(User.count).to eq 0
      end
      it 'should not be successful' do
        result = user_sign_up.sign_up('abc')
        expect(result).not_to be_successful
      end
      it 'sets error message' do
        result = user_sign_up.sign_up('abc')
        expect(result.error_message).to be_present
      end
      it 'does not send out welcome mail' do
        result = user_sign_up.sign_up('abc')
        expect(ActionMailer::Base.deliveries).to be_empty
      end
      it 'does not charge the card' do
        StripeWrapper::Charge.should_not_receive(:create)
        result = user_sign_up.sign_up('abc')
      end
    end

    context 'when credit card info is not valid' do
      let(:user) { Fabricate.build(:user) }
      let(:user_sign_up) { UserSignUp.new(user) }
      before { mock_failed_charge }
      it 'should not save to db' do
        result = user_sign_up.sign_up('abc')
        expect(User.count).to eq 0
      end
      it 'does not send out welcome mail' do
        result = user_sign_up.sign_up('abc')
        expect(ActionMailer::Base.deliveries).to be_empty
      end
      it 'sets error message' do
        result = user_sign_up.sign_up('abc')
        expect(result.error_message).to be_present
      end
      it 'does not charge the card' do
        StripeWrapper::Charge.should_not_receive(:create)
        result = user_sign_up.sign_up('abc')
      end
    end

    context "when sending welcome email" do
      let(:user) { Fabricate.build(:user) }
      let(:user_sign_up) { UserSignUp.new(user) }
      before { mock_valid_charge }

      it 'sends out the email' do
        result = user_sign_up.sign_up('abc')
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end
      it 'sends to the right recepient' do
        result = user_sign_up.sign_up('abc')
        expect(ActionMailer::Base.deliveries.last.to[0]).to eq user.email
      end
      it 'has the correct message content' do
        result = user_sign_up.sign_up('abc')
        expect(ActionMailer::Base.deliveries.last.body).to include user.full_name
      end
    end

  end
end
