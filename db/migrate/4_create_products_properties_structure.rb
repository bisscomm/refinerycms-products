class CreateProductsPropertiesStructure < ActiveRecord::Migration
  def up
    create_table :refinery_products_properties do |t|
      t.string :title
      t.integer :position

      t.timestamps
    end

    add_index :refinery_products_properties, :id

    create_table :refinery_products_properties_products do |t|
      t.integer :products_property_id
      t.integer :product_id
      t.text :value
    end

    add_index :refinery_products_properties_products, [:products_property_id, :product_id], :name => 'index_products_properties_products_on_pp_and_p'
  end

  def down
    drop_table :refinery_products_properties
    drop_table :refinery_products_properties_products
  end
end

