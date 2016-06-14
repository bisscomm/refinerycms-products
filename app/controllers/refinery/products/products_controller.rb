module Refinery
  module Products
    class ProductsController < ShopController
      include Refinery::Products::ControllerHelper

      before_action :find_page
      before_action :find_all_products
      before_action :find_product, only: :show

      def show
        @product_images = @product.images.includes(:translations)
        @root_category = @product.categories.root
        @root_category_products = @root_category.products
      end

      protected

      def find_page
        @page = Refinery::Page.find_by(:link_url => "#{Refinery::Products.shop_path}#{Refinery::Products.products_path}")
      end

      def find_product
        @product = Refinery::Products::Product.includes(:images, :translations).friendly.find(params[:id])
        
        if !@product.try(:live?)
          if current_refinery_user && current_refinery_user.has_plugin?("refinery_products")
            @product
          else
            error_404
          end
        end
      end

    end
  end
end
