require 'refinerycms-core'
require 'refinerycms-wymeditor'
require 'friendly_id'
require 'refinerycms-acts-as-indexed'

module Refinery
  autoload :ProductsGenerator, 'generators/refinery/products/products_generator'

  module Products
    require 'refinery/products/engine'
    require 'refinery/products/configuration'

    autoload :Tab, 'refinery/products/tabs'

    class << self
      attr_writer :root
      attr_writer :tabs

      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end

      def tabs
        @tabs ||= []
      end

      def factory_paths
        @factory_paths ||= [ root.join('spec', 'factories').to_s ]
      end
    end
  end
end
