module Refinery
  module Products
    module Admin
      class ProductsController < ::Refinery::AdminController

        crudify :'refinery/products/product',
                :order => 'title ASC',
                :include => [:translations]

        before_filter :find_all_categories,
                      :only => [:new, :edit, :create, :update]
        before_filter :find_all_properties,
                      :only => [:new, :edit, :create, :update]

        before_filter :check_category_ids, :only => :update
        before_filter :check_property_ids, :only => :update

        def uncategorized
          @products = Refinery::Products::Product.uncategorized.page(params[:page])
        end

        private
          def product_params
            params.require(:product).permit(
              :title,
              :body,
              :published_at,
              :draft,
              :category_ids => [],
              :property_ids => []
            )
          end

        protected

          def find_all_categories
            @categories = Refinery::Products::Category.all
          end

          def find_all_properties
            @properties = Refinery::Products::Property.all
          end

          def check_category_ids
            product_params[:category_ids] ||= []
          end

          def check_property_ids
            product_params[:property_ids] ||= []
          end

      end
    end
  end
end
