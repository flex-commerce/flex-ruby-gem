require "flex_commerce_api/api_base"
module FlexCommerce
  #
  # A flex commerce BuildTransaction model
  #
  # This model provides access to the flex commerce BuildTransaction which is used to
  # create a transaction via a payment processor for a cart when it is converted to an order
  #
  #
  #
  class BuildTransaction < FlexCommerceApi::ApiBase
    def error_meta
      errors.empty? ? nil : last_result_set.errors.first.meta
    end

  end
end
