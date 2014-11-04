class AddNestedToCategories < ActiveRecord::Migration
  def self.up
    add_column :refinery_products_categories, :parent_id, :integer # Comment this line if your project already has this column
    # Category.where(parent_id: 0).update_all(parent_id: nil) # Uncomment this line if your project already has :parent_id
    add_column :refinery_products_categories, :lft      , :integer
    add_column :refinery_products_categories, :rgt      , :integer
    add_column :refinery_products_categories, :depth    , :integer  # this is optional.

    # This is necessary to update :lft and :rgt columns
    Refinery::Products::Category.rebuild!
  end

  def self.down
    remove_column :refinery_products_categories, :parent_id
    remove_column :refinery_products_categories, :lft
    remove_column :refinery_products_categories, :rgt
    remove_column :refinery_products_categories, :depth  # this is optional.
  end
end