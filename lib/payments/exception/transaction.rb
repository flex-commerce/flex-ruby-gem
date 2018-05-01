require_relative 'base'
module FlexCommerce
  module Payments
    module Exception
      class Transaction < Base
        attr_accessor :transaction_id, :gateway_transaction_id, :response
        def initialize(message, options = {})
          options.each_pair do |attr, value|
            try("#{attr}=".to_sym, value)
          end
          super(message)
        end
      end
    end
  end
end
