module FlexCommerce
  def self.gem_root
    File.expand_path("../", __dir__)
  end
  autoload :Product, File.join(gem_root, "app", "models", "product")
  autoload :StaticPage, File.join(gem_root, "app", "models", "static_page")
  autoload :Variant, File.join(gem_root, "app", "models", "variant")
  autoload :MenuItem, File.join(gem_root, "app", "models", "menu_item")
  autoload :Menu, File.join(gem_root, "app", "models", "menu")
  autoload :BreadcrumbItem, File.join(gem_root, "app", "models", "breadcrumb_item")
  autoload :Breadcrumb, File.join(gem_root, "app", "models", "breadcrumb")
  autoload :Category, File.join(gem_root, "app", "models", "category")
  autoload :Cart, File.join(gem_root, "app", "models", "cart")
  autoload :Coupon, File.join(gem_root, "app", "models", "coupon")
  autoload :DiscountSummary, File.join(gem_root, "app", "models", "discount_summary")
  autoload :LineItem, File.join(gem_root, "app", "models", "line_item")
  autoload :CustomerAccount, File.join(gem_root, "app", "models", "customer_account")
  autoload :Address, File.join(gem_root, "app", "models", "address")
end
