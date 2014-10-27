class AddSlugToProductsAndCategories < ActiveRecord::Migration
  def change
    add_column Refinery::Products::Product.table_name, :slug, :string
    add_index Refinery::Products::Product.table_name, :slug

    add_column Refinery::Products::Category.table_name, :slug, :string
    add_index Refinery::Products::Category.table_name, :slug
  end
end
