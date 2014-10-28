module Refinery
  module Products
    class CategoriesController < ShopController
      include ControllerHelper

      before_filter :find_page
      before_filter :find_all_products_categories

      def show
        @category = Refinery::Products::Category.friendly.find(params[:id])
        @products = @category.products.live.includes(:categories).with_globalize.page(params[:page])
      end

      protected

        def find_page
          @page = Refinery::Page.find_by(:link_url => "#{Refinery::Products.shop_path}#{Refinery::Products.products_categories_path}")
        end
    end
  end
end
