class CreatePropertyCategoryLocations < ActiveRecord::Migration
  def self.up
    create_table :property_category_locations do |t|
      t.boolean :active
      t.integer :position
      t.timestamps
    end

    PropertyCategoryLocation.create_translation_table! :name => :string
  end
  
  def self.down
    drop_table :property_category_locations
    PropertyCategoryLocation.drop_translation_table!
  end
end
