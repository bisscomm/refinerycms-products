module Refinery
  module Products
    class Categorization < ActiveRecord::Base
      self.table_name = 'refinery_products_categories_products'

      belongs_to :product,           :class_name => 'Refinery::Products::Product',  :foreign_key => :product_id
      belongs_to :products_category, :class_name => 'Refinery::Products::Category', :foreign_key => :products_category_id
    end
  end
end