module Refinery
  module Products
    module Admin
      class CategoriesController < ::Refinery::AdminController

        crudify :'refinery/products/category',
                :order => 'title ASC'

        private
          def category_params
            params.require(:category).permit(:title, :parent_id)
          end
      end
    end
  end
end
