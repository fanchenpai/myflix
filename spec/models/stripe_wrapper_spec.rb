require 'spec_helper'

describe StripeWrapper, :vcr do # :vcr => { record: :all } to re-record
  let(:token) do
    Stripe::Token.create(
      :card => {
        :number => card_number,
        :exp_month => 4,
        :exp_year => Time.now.year + 1,
        :cvc => "314"
      }
    )
  end

  describe ".set_api_key" do
    let(:card_number) { "4242424242424242" }
    before { Stripe.api_key = nil }
    it "should make any Stripe method call failed if not invoked first" do
      expect { token }.to raise_error(Stripe::AuthenticationError)
    end
    it "should allow following Stripe method call successful if invoked" do
      StripeWrapper.set_api_key
      expect(token.id).to be_present
    end
  end

  describe StripeWrapper::Charge do
    describe ".create" do
      before { StripeWrapper.set_api_key }
      context "with valid card number" do
        let(:card_number) { "4242424242424242" }
        it "should be successful" do
          charge = StripeWrapper::Charge.create(
            amount: 999,
            card: token.id,
            description: "test StripeWrapper::Charge.create"
          )
          expect(charge).to be_successful
          expect(charge.response.amount).to eq 999
          expect(charge.response.currency).to eq "usd"
          expect(charge.response.paid).to be_true
        end
      end
      context "without valid card number" do
        let(:card_number) { "4000000000000002" }
        let(:charge) do
          StripeWrapper::Charge.create(
            amount: 999,
            card: token.id,
            description: "test StripeWrapper::Charge.create"
          )
        end
        it "should not be successful" do
          expect(charge).not_to be_successful
        end
        it "should set error message" do
          expect(charge.error_message).to include "declined"
        end
      end
    end
  end

end
