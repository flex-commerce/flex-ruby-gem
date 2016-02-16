module FlexCommerce
  def self.gem_root
    File.expand_path("../", __dir__)
  end

  # Models
  autoload :Product, File.join(gem_root, "app", "models", "product")
  autoload :StaticPage, File.join(gem_root, "app", "models", "static_page")
  autoload :Variant, File.join(gem_root, "app", "models", "variant")
  autoload :MenuItem, File.join(gem_root, "app", "models", "menu_item")
  autoload :Menu, File.join(gem_root, "app", "models", "menu")
  autoload :BreadcrumbItem, File.join(gem_root, "app", "models", "breadcrumb_item")
  autoload :Breadcrumb, File.join(gem_root, "app", "models", "breadcrumb")
  autoload :Category, File.join(gem_root, "app", "models", "category")
  autoload :CategoryTree, File.join(gem_root, "app", "models", "category_tree")
  autoload :Cart, File.join(gem_root, "app", "models", "cart")
  autoload :Coupon, File.join(gem_root, "app", "models", "coupon")
  autoload :DiscountSummary, File.join(gem_root, "app", "models", "discount_summary")
  autoload :LineItem, File.join(gem_root, "app", "models", "line_item")
  autoload :CustomerAccount, File.join(gem_root, "app", "models", "customer_account")
  autoload :Address, File.join(gem_root, "app", "models", "address")
  autoload :ShippingMethod, File.join(gem_root, "app", "models", "shipping_method")
  autoload :Order, File.join(gem_root, "app", "models", "order")
  autoload :OrderTransaction, File.join(gem_root, "app", "models", "order_transaction")
  autoload :OrderTransactionAuth, File.join(gem_root, "app", "models", "order_transaction_auth")
  autoload :OrderTransactionVoid, File.join(gem_root, "app", "models", "order_transaction_void")
  autoload :PaymentProvider, File.join(gem_root, "app", "models", "payment_provider")
  autoload :PaymentProviderSetup, File.join(gem_root, "app", "models", "payment_provider_setup")
  autoload :TemplateDefinition, File.join(gem_root, "app", "models", "template_definition")
  autoload :SearchSuggestion, File.join(gem_root, "app", "models", "search_suggestion")
  autoload :AssetFile, File.join(gem_root, "app", "models", "asset_file")
  autoload :Country, File.join(gem_root, "app", "models", "country")
  autoload :Promotion, File.join(gem_root, "app", "models", "promotion")
  autoload :StockLevel, File.join(gem_root, "app", "models", "stock_level")
  autoload :BundleGroup, File.join(gem_root, "app", "models", "bundle_group")
  autoload :Refund, File.join(gem_root, "app", "models", "refund")
  
  # Services
  autoload :ParamToShql, File.join(gem_root, "app", "services", "param_to_shql")
end
