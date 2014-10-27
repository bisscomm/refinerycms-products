module Refinery
  module Products
    module Admin
      class ProductsController < ::Refinery::AdminController

        crudify :'refinery/products/product',
                :xhr_paging => true

        before_filter :find_all_categories,
                      :only => [:new, :edit, :create, :update]

        before_filter :check_category_ids, :only => :update

        private
          def product_params
            params.require(:product).permit(
              :title,
              :body,
              :published_at,
              :draft,
              :category_ids => []
            )
          end

        protected

          def find_all_categories
            @categories = Refinery::Products::Category.all
          end

          def check_category_ids
            product_params[:category_ids] ||= []
          end

      end
    end
  end
end
