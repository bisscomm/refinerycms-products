module Refinery
  module Products
    module Admin
      class CategoriesController < ::Refinery::AdminController

        crudify :'refinery/products/category',
                :order => "lft ASC",
                :include => [:translations, :children],
                :paging => false

        def new
          @category = Category.new(new_category_params)
        end

        def children
          @category = find_category
          render :layout => false
        end

        protected
          def after_update_positions
            find_all_categories
            render :partial => '/refinery/admin/categories/sortable_list' and return
          end

          def find_category
            @category = Category.find_by_path_or_id!(params[:path], params[:id])
          end
          alias_method :category, :find_category

          # We can safely assume ::Refinery::I18n is defined because this method only gets
          # Invoked when the before_action from the plugin is run.
          def globalize!
            return super unless action_name.to_s == 'index'

            # Always display the tree of pages from the default frontend locale.
            if Refinery::I18n.built_in_locales.keys.map(&:to_s).include?(params[:switch_locale])
              Globalize.locale = params[:switch_locale].try(:to_sym)
            else
              Globalize.locale = Refinery::I18n.default_frontend_locale
            end
          end

        protected
          def after_update_positions
            find_all_pages
            render :partial => '/refinery/admin/pages/sortable_list' and return
          end

          def category_params
            params.require(:category).permit(:title, :photo_id, :parent_id, :promote)
          end

          def new_category_params
            params.permit(:parent_id)
          end
      end
    end
  end
end
