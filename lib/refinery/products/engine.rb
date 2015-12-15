module Refinery
  module Products
    class Engine < Rails::Engine
      include Refinery::Engine

      isolate_namespace Refinery::Products

      initializer "register refinerycms_products plugin" do
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = "refinerycms_products"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.products_admin_products_path }
          plugin.menu_match = /refinery\/products\/?(products|categories)?/
        end
      end

      config.to_prepare do
        Rails.application.config.assets.precompile += %w(refinery/products/backend.js refinery/products/backend.css)
      end

      config.after_initialize do
        Refinery.register_engine(Refinery::Products)
      end
    end
  end
end