module Refinery
  module Products
    module ControllerHelper

      protected

      def find_product
        unless (@product = Refinery::Products::Product.with_translations(::I18n.locale).friendly.find(params[:id])).try(:live?)
          if current_refinery_user && current_refinery_user.has_plugin?("refinery_products")
            @product = Refinery::Products::Product.with_translations(::I18n.locale).friendly.find(params[:id])
          else
            error_404
          end
        end
      end

      def find_all_products
        @products = Refinery::Products::Product.live.includes(:categories).with_translations(::I18n.locale).newest_first.page(params[:page])
      end

      def find_all_root_categories
        @root_categories = Refinery::Products::Category.includes(:photo).with_translations(::I18n.locale).where(parent_id: nil).order(:lft)
      end

      def find_all_categories
        @categories = Refinery::Products::Category.includes(:children, :photo).with_translations(::I18n.locale).order(:lft)
      end

      def find_all_promoted_root_categories
        @promoted_root_categories = Refinery::Products::Category.includes(:photo).with_translations(::I18n.locale).where(parent_id: nil, promote: 1).order(:lft)
      end
    end
  end
end