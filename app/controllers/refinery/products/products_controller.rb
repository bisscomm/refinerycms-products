module Refinery
  module Products
    class ProductsController < ShopController
      include Refinery::Products::ControllerHelper

      before_action :find_page
      before_action :find_all_products
      before_action :find_product, only: :show

      def show
        @product_images = @product.images
        @root_category = @product.categories.root
        @root_category_products = @root_category.products
      end

      protected

        def find_page
          @page = Refinery::Page.find_by(:link_url => "#{Refinery::Products.shop_path}#{Refinery::Products.products_path}")
        end

    end
  end
end
