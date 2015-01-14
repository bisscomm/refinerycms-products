module Refinery
  module Products
    class Property < Refinery::Core::BaseModel
      translates :title

      has_many :propertizations, :dependent => :destroy, :foreign_key => :products_property_id
      has_many :products, :through => :propertizations, :source => :product

      validates :title, :presence => true, :uniqueness => true

      acts_as_indexed :fields => [:title]

      default_scope { order(position: :asc) }

      def self.translated
        with_translations(::Globalize.locale)
      end

      self.per_page = Refinery::Products.products_per_page
    end
  end
end
