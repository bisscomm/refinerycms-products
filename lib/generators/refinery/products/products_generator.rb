module Refinery
  class ProductsGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def generate_products_initializer
      template 'config/initializers/refinery/products.rb.erb', File.join(destination_root, 'config', 'initializers', 'refinery', 'products.rb')
    end

    def rake_db
      rake "refinery_products:install:migrations"
    end

    def append_load_seed_data
      create_file 'db/seeds.rb' unless File.exists?(File.join(destination_root, 'db', 'seeds.rb'))
      append_file 'db/seeds.rb', :verbose => true do
        <<-EOH

# Added by Refinery CMS Products extension
Refinery::Products::Engine.load_seed
        EOH
      end
    end
  end
end
