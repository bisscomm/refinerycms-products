module Refinery
  module Products
    include ActiveSupport::Configurable

    config_accessor :products_per_page
    config_accessor :shop_path, :products_path, :products_categories_path

    self.products_per_page = 10
    self.shop_path = "/shop"
    self.products_path = "/products"
    self.products_categories_path = "/categories"
  end
end