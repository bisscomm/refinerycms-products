class AddFieldBodyToCategories < ActiveRecord::Migration
  def change
    add_column :refinery_products_categories, :body, :text
  end
end
