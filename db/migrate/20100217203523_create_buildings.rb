class CreateBuildings < ActiveRecord::Migration
  def self.up
    create_table :buildings do |t|
      t.integer :building_type_id
      t.integer :property_type_id
      t.float :area
      t.timestamps
    end

    Building.create_translation_table! :description => :string
  end
  
  def self.down
    drop_table :buildings
    Building.drop_translation_table!
  end
end
