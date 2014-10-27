module Refinery
  module Products
    module Admin
      class CategoriesController < ::Refinery::AdminController

        crudify :'refinery/products/category',
                :xhr_paging => true

      end
    end
  end
end
