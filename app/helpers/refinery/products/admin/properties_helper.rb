module Refinery
  module Products
    module Admin
      module PropertiesHelper
        def property_title_with_translations(property)
          property.title.presence || property.translations.detect { |t| t.title.present?}.title
        end
      end
    end
  end
end