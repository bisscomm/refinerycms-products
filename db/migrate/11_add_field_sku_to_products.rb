class AddFieldSkuToProducts < ActiveRecord::Migration
  def change
    add_column Refinery::Products::Product.table_name, :sku, :string
  end
end
