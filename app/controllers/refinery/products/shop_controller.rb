module Refinery
  module Products
    class ShopController < ::ApplicationController
      include Refinery::Products::ControllerHelper

      helper :'refinery/products/products'

      before_filter :find_page, :find_all_root_products_categories

      protected

        def find_page
          @page = Refinery::Page.find_by(:link_url => Refinery::Products.shop_path)
        end
    end
  end
end