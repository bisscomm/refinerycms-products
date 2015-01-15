module Refinery
  module Products
    class CategoriesController < ShopController
      include Refinery::Products::ControllerHelper

      before_action :find_category

      def show
        if should_redirect_to_friendly_url?
          redirect_to refinery.url_for(category.url), :status => 301 and return
        end

        @products = @category.products.live.includes(:categories).with_globalize.order('title ASC').page(params[:page])
      end

    protected

      def requested_friendly_id
        if ::Refinery::Pages.scope_slug_by_parent
          # Pick out last path component, or id if present
          "#{params[:path]}/#{params[:id]}".split('/').last
        else
          # Remove leading and trailing slashes in path, but leave internal
          # ones for global slug scoping
          params[:path].to_s.gsub(%r{\A/+}, '').presence || params[:id]
        end
      end

      def should_redirect_to_friendly_url?
        requested_friendly_id != category.friendly_id || ::Refinery::Pages.scope_slug_by_parent && params[:path].present? && params[:path].match(category.root.slug).nil?
      end

      def first_live_child
        category.children.order('lft ASC').live.first
      end

      def find_category(fallback_to_404 = true)
        @category ||= case action_name
                  when "index"
                    Refinery::Page.find_by(:link_url => "#{Refinery::Products.shop_path}#{Refinery::Products.products_categories_path}")
                  when "show"
                    Refinery::Products::Category.find_by_path_or_id(params[:path], params[:id])
                  end
        @category || (error_404 if fallback_to_404)
      end

      alias_method :category, :find_category
    end
  end
end