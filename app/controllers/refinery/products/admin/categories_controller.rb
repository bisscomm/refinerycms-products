module Refinery
  module Products
    module Admin
      class CategoriesController < ::Refinery::AdminController

        crudify :'refinery/products/category',
                :order => 'title ASC'

        private
          def category_params
            params.require(:category).permit(:title, :photo_id, :parent_id, :promote)
          end
      end
    end
  end
end
