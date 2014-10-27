class CreateProductsAndCategoriesTranslations < ActiveRecord::Migration
  def up
    Refinery::Products::Product.create_translation_table!({
      :body => :text,
      :slug => :string,
      :title => :string
    }, {
      :migrate_data => true
    })

    Refinery::Products::Category.create_translation_table!({
      :slug => :string,
      :title => :string
    }, {
      :migrate_data => true
    })
  end

  def down
    Refinery::Products::Product.drop_translation_table! :migrate_data => true
    Refinery::Products::Category.drop_translation_table! :migrate_data => true
  end
end
