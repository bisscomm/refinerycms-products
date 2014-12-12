class AddPhotoToProductsCategories < ActiveRecord::Migration
  def change
    add_column Refinery::Products::Category.table_name, :photo_id, :integer
  end
end
