module StripeWrapper

  def self.set_api_key
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
  end

  class Charge
    attr_reader :response

    def initialize(response, status)
      @response = response
      @status = status
    end

    def self.create(options={})
      StripeWrapper.set_api_key
      begin
        charge = Stripe::Charge.create(
          amount: options[:amount],
          currency: "usd",
          card: options[:card],
          description: options[:description]
        )
        new(charge, :success)
      rescue Stripe::CardError => e
        new(e, :error)
      rescue => e
        #flash[:error] = "Sorry, we are not able to process your payment at this time. Please try again later."
        #AdminMailer.delay.error_notification('Stripe error',e.message)
        new(e, :error)
      end
    end

    def successful?
      @status == :success
    end

    def error_message
      @response.message
    end

  end
end
