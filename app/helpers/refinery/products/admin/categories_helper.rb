module Refinery
  module Products
    module Admin
      module CategoriesHelper
        def parent_id_nested_set_options(current_category)
          categories = []
          nested_set_options(::Refinery::Products::Category, current_category) {|category| categories << category}
          # category.title needs the :translations association, doing something like
          # nested_set_options(::Refinery::Products::Category.includes(:translations), category) doesn't work, yet.
          # See https://github.com/collectiveidea/awesome_nested_set/pull/123
          ActiveRecord::Associations::Preloader.new.preload(categories, :translations)
          categories.map {|category| ["#{'-' * category.level} #{category.title}", category.id]}
        end
      end
    end
  end
end