module Refinery
  module Products
    module Admin
      module ProductsHelper
        def setup_product(product)
          (Property.all - product.properties).each do |property|
            product.propertizations.build(:products_property => property)
          end
          product.propertizations.sort_by! {|pp| pp.products_property.title }
        end
      end
    end
  end
end