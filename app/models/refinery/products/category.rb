# Encoding: utf-8
require 'friendly_id'
require 'refinery/core/base_model'
require 'refinery/products/categories/url'
require 'refinery/products/categories/finder'

module Refinery
  module Products
    class Category < Refinery::Core::BaseModel
      extend FriendlyId

      translates :title, :slug

      class FriendlyIdOptions
        def self.reserved_words
          %w(index new session login logout users refinery admin images)
        end

        def self.options
          # Docs for friendly_id https://github.com/norman/friendly_id
          friendly_id_options = {
            use: [:reserved],
            reserved_words: self.reserved_words
          }

          friendly_id_options[:use] << :scoped
          friendly_id_options.merge!(scope: :parent)

          friendly_id_options[:use] << :globalize
          friendly_id_options
        end
      end

      # If title changes tell friendly_id to regenerate slug when saving record
      def should_generate_new_friendly_id?
        changes.keys.include?("title")
      end

      validates :title, :presence => true

      # Docs for acts_as_nested_set https://github.com/collectiveidea/awesome_nested_set
      # rather than :delete_all we want :destroy
      acts_as_nested_set :dependent => :destroy

      friendly_id :custom_slug_or_title, FriendlyIdOptions.options

      belongs_to :photo, :class_name => '::Refinery::Image'

      has_many :categorizations, :dependent => :destroy, :foreign_key => :products_category_id
      has_many :products, :through => :categorizations, :source => :product

      acts_as_indexed :fields => [:title]

      class << self
        # Find categories by path, checking for scoping rules
        def find_by_path(path)
          Products::Categories::Finder.by_path(path)
        end

        # Helps to resolve the situation where you have a path and an id
        # and if the path is unfriendly then a different finder method is required
        # than find_by_path.
        def find_by_path_or_id(path, id)
          Products::Categories::Finder.by_path_or_id(path, id)
        end

        # Helps to resolve the situation where you have a path and an id
        # and if the path is unfriendly then a different finder method is required
        # than find_by_path.
        #
        # raise ActiveRecord::RecordNotFound if not found.
        def find_by_path_or_id!(path, id)
          category = find_by_path_or_id(path, id)

          raise ActiveRecord::RecordNotFound unless category

          category
        end

        # Finds categories by their title.  This method is necessary because categories
        # are translated which means the title attribute does not exist on the
        # categories table thus requiring us to find the attribute on the translations table
        # and then join to the categories table again to return the associated record.
        def by_title(title)
          Products::Categories::Finder.by_title(title)
        end

        # Finds categories by their slug.  This method is necessary because categories
        # are translated which means the slug attribute does not exist on the
        # categories table thus requiring us to find the attribute on the translations table
        # and then join to the categories table again to return the associated record.
        def by_slug(slug, conditions = {})
          Products::Categories::Finder.by_slug(slug, conditions)
        end

        # Wrap up the logic of finding the categories based on the translations table.
        def with_globalize(conditions = {})
          Products::Categories::Finder.with_globalize(conditions)
        end

        def rebuild_with_slug_nullification!
          rebuild_without_slug_nullification!
          nullify_duplicate_slugs_under_the_same_parent!
        end
        alias_method_chain :rebuild!, :slug_nullification

        protected

        def nullify_duplicate_slugs_under_the_same_parent!
          t_slug = translation_class.arel_table[:slug]
          joins(:translations).group(:locale, :parent_id, t_slug).having(t_slug.count.gt(1)).count.
          each do |(locale, parent_id, slug), count|
            by_slug(slug, :locale => locale).where(:parent_id => parent_id).drop(1).each do |category|
              category.slug = nil # kill the duplicate slug
              category.save # regenerate the slug
            end
          end
        end
      end

      def translated_to_default_locale?
        persisted? && translations.any?{ |t| t.locale == Refinery::I18n.default_frontend_locale}
      end

      # The canonical category for this particular category.
      # Consists of:
      #   * The default locale's translated slug
      def canonical
        Globalize.with_locale(::Refinery::I18n.default_frontend_locale) { url }
      end

      # The canonical slug for this particular category.
      # This is the slug for the default frontend locale.
      def canonical_slug
        Globalize.with_locale(::Refinery::I18n.default_frontend_locale) { slug }
      end

      # Returns in cascading order: custom_slug or menu_title or title depending on
      # which attribute is first found to be present for this page.
      def custom_slug_or_title
        title.presence
      end

      # Returns the full path to this category.
      # This automatically prints out this category title and all parent category titles.
      # The result is joined by the path_separator argument.
      def path(path_separator: ' - ', ancestors_first: true)
        return title if root?

        chain = ancestors_first ? self_and_ancestors : self_and_ancestors.reverse
        chain.map(&:title).join(path_separator)
      end

      def url
        ::Refinery::Products::Categories::Url.build(self)
      end

      def nested_url
        Globalize.with_locale(slug_locale) do
          if !root?
            self_and_ancestors.includes(:translations).map(&:to_param)
          else
            [to_param.to_s]
          end
        end
      end

      # Returns an array with all ancestors to_param, allow with its own
      # Ex: with an About category and a Mission underneath,
      # ::Refinery::Products::Category.find('mission').nested_url would return:
      #
      #   ['about', 'mission']
      #
      alias_method :uncached_nested_url, :nested_url

      # Returns the string version of nested_url, i.e., the path that should be
      # generated by the router
      def nested_path
        ['', nested_url].join('/')
      end

      def to_refinery_menu_item
        {
          :id => id,
          :lft => lft,
          :depth => depth,
          :menu_match => menu_match,
          :parent_id => parent_id,
          :rgt => rgt,
          # :title => menu_title.presence || title.presence,
          :title => title.presence,
          :type => self.class.name,
          :url => url
        }
      end

      private

      class FriendlyIdPath
        def self.normalize_friendly_id_path(slug_string)
          # Remove leading and trailing slashes, but allow internal
          slug_string
            .sub(%r{^/*}, '')
            .sub(%r{/*$}, '')
            .split('/')
            .select(&:present?)
            .map { |slug| self.normalize_friendly_id_with_marketable_urls(slug) }.join('/')
        end

        def self.normalize_friendly_id_with_marketable_urls(slug_string)
          # If we are scoping by parent, no slashes are allowed. Otherwise, slug is
          # potentially a custom slug that contains a custom route to the page.
          if slug_string.include?('/')
            self.normalize_friendly_id_path(slug_string)
          else
            self.protected_slug_string(slug_string)
          end
        end

        def self.protected_slug_string(slug_string)
          sluggified = slug_string.to_slug.normalize!
          sluggified << "-category" if FriendlyIdOptions.reserved_words.include?(sluggified)
          sluggified
        end
      end

      # Protects generated slugs from title if they are in the list of reserved words
      # This applies mostly to plugin-generated pages.
      # This only kicks in when Refinery::Pages.marketable_urls is enabled.
      # Also check for global scoping, and if enabled, allow slashes in slug.
      #
      # Returns the sluggified string
      def normalize_friendly_id_with_marketable_urls(slug_string)
        FriendlyIdPath.normalize_friendly_id_with_marketable_urls(slug_string)
      end
      alias_method_chain :normalize_friendly_id, :marketable_urls

      def slug_locale
        return Globalize.locale if translation_for(Globalize.locale).try(:slug).present?

        if translations.empty? || translation_for(Refinery::I18n.default_frontend_locale).present?
          Refinery::I18n.default_frontend_locale
        else
          translations.first.locale
        end
      end
    end
  end
end