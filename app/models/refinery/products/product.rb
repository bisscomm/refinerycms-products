module Refinery
  module Products
    class Product < Refinery::Core::BaseModel
      extend FriendlyId

      self.table_name = 'refinery_products'

      translates :title, :body, :slug

      friendly_id :friendly_id_source, :use => [:slugged, :globalize]

      belongs_to :file, :class_name => '::Refinery::Resource'

      has_many_page_images

      has_many :categorizations, :dependent => :destroy, :foreign_key => :product_id
      has_many :categories, :through => :categorizations, :source => :products_category

      has_many :propertizations, :dependent => :destroy, :foreign_key => :product_id
      has_many :properties, :through => :propertizations, :source => :products_property

      accepts_nested_attributes_for :propertizations, allow_destroy: true

      validates :title, :presence => true, :uniqueness => true
      validates :published_at, :presence => true

      acts_as_indexed :fields => [:title, :body]

      # If title changes tell friendly_id to regenerate slug when
      # saving record
      def should_generate_new_friendly_id?
        title_changed?
      end

      self.per_page = Refinery::Products.products_per_page

      def live?
        !draft && published_at <= Time.now
      end

      class << self

        # Wrap up the logic of finding the pages based on the translations table.
        def with_globalize(conditions = {})
          conditions = {:locale => ::Globalize.locale}.merge(conditions)
          globalized_conditions = {}
          conditions.keys.each do |key|
            if (translated_attribute_names.map(&:to_s) | %w(locale)).include?(key.to_s)
              globalized_conditions["#{self.translation_class.table_name}.#{key}"] = conditions.delete(key)
            end
          end
          # A join implies readonly which we don't really want.
          where(conditions).joins(:translations).where(globalized_conditions)
                           .readonly(false)
        end

        def newest_first
          order("published_at DESC")
        end

        def uncategorized
          newest_first.live.includes(:categories).where(
            Refinery::Products::Categorization.table_name => { :products_category_id => nil }
          )
        end

        def published_before(date=Time.now)
          where(arel_table[:published_at].lt(date))
            .where(:draft => false)
            .with_globalize
        end
        alias_method :live, :published_before
      end
    end
  end
end
