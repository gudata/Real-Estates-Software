class CreatePropertyLocations < ActiveRecord::Migration
  def self.up
    create_table :property_locations do |t|
      t.boolean :active
      t.string :position
      t.timestamps
    end

    PropertyLocation.create_translation_table! :name => :string
  end
  
  def self.down
    drop_table :property_locations
    PropertyLocation.drop_translation_table!
  end
end
