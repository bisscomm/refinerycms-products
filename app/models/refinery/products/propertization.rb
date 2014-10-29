module Refinery
  module Products
    class Propertization < ActiveRecord::Base
      self.table_name = 'refinery_products_properties_products'

      belongs_to :product,           :class_name => 'Refinery::Products::Product',  :foreign_key => :product_id
      belongs_to :products_property, :class_name => 'Refinery::Products::Property', :foreign_key => :products_property_id
    end
  end
end