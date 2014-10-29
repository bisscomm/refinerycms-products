module Refinery
  module Products
    module Admin
      class PropertiesController < ::Refinery::AdminController

        crudify :'refinery/products/property',
                :order => 'title ASC'

        private
          def property_params
            params.require(:property).permit(:title)
          end
      end
    end
  end
end
