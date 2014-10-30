class CreatePropertiesTranslations < ActiveRecord::Migration
  def up
    Refinery::Products::Property.create_translation_table!({
      :title => :string
    }, {
      :migrate_data => true
    })

    Refinery::Products::Propertization.create_translation_table!({
      :value => :string
    }, {
      :migrate_data => true
    })
  end

  def down
    Refinery::Products::Property.drop_translation_table! :migrate_data => true
    Refinery::Products::Propertization.drop_translation_table! :migrate_data => true
  end
end