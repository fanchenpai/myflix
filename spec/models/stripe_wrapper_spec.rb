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

  describe StripeWrapper::Charge do
    describe ".create" do
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
