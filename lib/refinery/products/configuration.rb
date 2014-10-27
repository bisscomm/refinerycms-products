module Refinery
  module Products
    include ActiveSupport::Configurable

    config_accessor :products_per_page
    config_accessor :page_path_products_index, :page_path_products_categories_index

    self.products_per_page = 10
    self.page_path_products_index = "/products"
    self.page_path_products_categories_index = "/products/categories"
  end
end