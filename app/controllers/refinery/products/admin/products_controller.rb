module Refinery
  module Products
    module Admin
      class ProductsController < ::Refinery::AdminController

        crudify :'refinery/products/product',
                include: [:translations, :categories, :properties],
                order: :published_at

        helper :'refinery/products/admin/categories'

        before_action :find_all_categories,
                      only: [:new, :edit, :create, :update]

        before_action :check_category_ids, only: :update

        def uncategorized
          @products = Refinery::Products::Product.uncategorized.page(params[:page])
        end

        private
          def product_params
            params.require(:product).permit(
              :title,
              :sku,
              :body,
              :published_at,
              :draft,
              :file_id,
              images_attributes: [:id, :caption],
              propertizations_attributes: [ :id, :product_id, :products_property_id, :value, :_destroy ],
              category_ids: []
            )
          end

        protected
          def find_product
            @product = Refinery::Products::Product.find_by_slug_or_id(params[:id])
          end

          def find_all_categories
            @categories = Refinery::Products::Category.includes(:children, :translations, :photo).all
          end

          def check_category_ids
            params[:product][:category_ids] ||= []
          end
      end
    end
  end
end
