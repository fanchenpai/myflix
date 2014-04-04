module StripeWrapper

  class Charge
    attr_reader :response

    def initialize(response, status)
      @response = response
      @status = status
    end

    def self.create(options={})
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
