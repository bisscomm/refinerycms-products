module Refinery
  module Products
    class Category < Refinery::Core::BaseModel
      extend FriendlyId
      acts_as_nested_set

      translates :title, :slug

      friendly_id :title, :use => [:slugged, :globalize]

      has_many :categorizations, :dependent => :destroy, :foreign_key => :products_category_id
      has_many :products, :through => :categorizations, :source => :product

      validates :title, :presence => true, :uniqueness => true

      acts_as_indexed :fields => [:title]

      def self.translated
        with_translations(::Globalize.locale)
      end

      def product_count
        products.live.with_globalize.count
      end

      self.per_page = Refinery::Products.products_per_page
    end
  end
end
