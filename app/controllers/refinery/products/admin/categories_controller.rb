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

        def update
          if @category.update_attributes(category_params)
            flash.notice = t('refinery.crudify.updated', what: "'#{@category.title}'")

            if from_dialog?
              self.index
              @dialog_successful = true
              render :index
            else
              if params[:continue_editing] =~ /true|on|1/
                if request.xhr?
                  render partial: 'save_and_continue_callback',
                         locals: save_and_continue_locals(@category)
                else
                  redirect_to :back
                end
              else
                redirect_back_or_default(refinery.admin_products_category_path)
              end
            end
          else
            if request.xhr?
              render :partial => '/refinery/admin/error_messages', :locals => {
                :object => @category,
                :include_object_name => true
              }
            else
              render 'edit'
            end
          end
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
            find_all_categories
            render :partial => '/refinery/admin/pages/sortable_list' and return
          end

          def category_params
            params.require(:category).permit(:title, :link_url, :photo_id, :parent_id, :promote)
          end

          def new_category_params
            params.permit(:parent_id)
          end
      end
    end
  end
end
