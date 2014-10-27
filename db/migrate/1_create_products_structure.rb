class CreateProductsStructure < ActiveRecord::Migration

  def up
    create_table :refinery_products do |t|
      t.string :title
      t.text :body
      t.boolean :draft, default: true
      t.datetime :published_at
      t.integer :position

      t.timestamps
    end

    add_index :refinery_products, :id

    create_table :refinery_products_categories do |t|
      t.string :title
      t.integer :position

      t.timestamps
    end

    add_index :refinery_products_categories, :id

    create_table :refinery_products_categories_products do |t|
      t.integer :products_category_id
      t.integer :product_id
    end

    add_index :refinery_products_categories_products, [:products_category_id, :product_id], :name => 'index_products_categories_products_on_pc_and_p'

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-products"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all(:link_url => Refinery::Products.page_path_products_index)
      ::Refinery::Page.delete_all(:link_url => Refinery::Products.page_path_products_categories_index)
    end

    drop_table :refinery_products
    drop_table :refinery_products_categories
    drop_table :refinery_products_categories_products
  end

end