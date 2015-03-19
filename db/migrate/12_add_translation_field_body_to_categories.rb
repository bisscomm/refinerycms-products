class AddTranslationFieldBodyToCategories < ActiveRecord::Migration
  def up
    Refinery::Products::Category.add_translation_fields! body: :text
  end

  def down
    remove_column :refinery_products_category_translations, :body
  end
end