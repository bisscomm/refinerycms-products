module Refinery
  module Products
    module Categories
      class Url

        class Localised < Url
          def self.handle?(category)
            category.link_url.present?
          end

          def url
            current_url = category.link_url

            if current_url =~ %r{^/} &&
              Refinery::I18n.current_frontend_locale != Refinery::I18n.default_frontend_locale
              current_url = "/#{Refinery::I18n.current_frontend_locale}#{current_url}"
            end

            current_url
          end
        end

        class Marketable < Url
          def self.handle?(category)
            Refinery::Products::Categories.marketable_urls
          end

          def url
            url_hash = base_url_hash.merge(:path => category.nested_url, :id => nil)
            with_locale_param(url_hash)
          end
        end

        class Normal < Url
          def self.handle?(category)
            category.to_param.present?
          end

          def url
            url_hash = base_url_hash.merge(:path => nil, :id => category.to_param)
            with_locale_param(url_hash)
          end
        end

        def self.build(category)
          klass = [ Localised, Marketable, Normal ].detect { |d| d.handle?(category) } || self
          klass.new(category).url
        end

        def initialize(category)
          @category = category
        end

        def url
          raise NotImplementedError
        end

        private

        attr_reader :category

        def with_locale_param(url_hash)
          if (locale = Refinery::I18n.current_frontend_locale) != ::I18n.locale
            url_hash.update :locale => locale if locale
          end
          url_hash
        end

        def base_url_hash
          { :controller => '/refinery/categories', :action => 'show', :only_path => true }
        end

      end
    end
  end
end