module Refinery
  module Products
    module ControllerHelper

      protected

        def find_product
          unless (@product = Refinery::Products::Product.with_globalize.friendly.find(params[:id])).try(:live?)
            if refinery_user? and current_refinery_user.authorized_plugins.include?("refinerycms_products")
              @product = Refinery::Products::Product.friendly.find(params[:id])
            else
              error_404
            end
          end
        end

        def find_all_products
          @products = Refinery::Products::Product.live.includes(:categories).with_globalize.newest_first.page(params[:page])
        end

        def find_all_products_categories
          @categories = Refinery::Products::Category.translated
        end
    end
  end
end