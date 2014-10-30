module Refinery
  module Products
    module Admin
      module ProductsHelper
        def setup_product(product)
          (Property.order('title ASC') - product.properties).each do |property|
            product.propertizations.build(:products_property => property)
          end
          product
        end
      end
    end
  end
end