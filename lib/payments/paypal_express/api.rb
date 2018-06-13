require "active_support/concern"
module FlexCommerce
  module Payments
    module PaypalExpress
      # A concern for use in paypal express services that need access to the API
      # See https://developer.paypal.com/docs/classic/api/errors/ for error code details
      module Api
        extend ActiveSupport::Concern

        private

        def convert_amount(amount)
          (amount * 100.0).round.to_i
        end

        def gateway
          @gateway ||= gateway_class.new(test: payment_provider.test_mode, login: payment_provider.meta_attributes["login"]["value"], password: payment_provider.meta_attributes["password"]["value"], signature: payment_provider.meta_attributes["signature"]["value"])
        end

        def response_error_codes(response)
          response.params["error_codes"].split(",")
        end

      end
    end
  end
end
