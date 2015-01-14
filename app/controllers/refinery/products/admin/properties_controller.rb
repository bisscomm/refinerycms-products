module Refinery
  module Products
    module Admin
      class PropertiesController < ::Refinery::AdminController

        crudify :'refinery/products/property',
                :order => 'position ASC',
                :include => [:translations],
                :paging => false


        protected
          def after_update_positions
            find_all_properties
            render :partial => '/refinery/products/admin/properties/sortable_list' and return
          end

        private
          def property_params
            params.require(:property).permit(:title)
          end
      end
    end
  end
end
