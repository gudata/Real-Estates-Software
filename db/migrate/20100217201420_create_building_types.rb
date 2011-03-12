class CreateBuildingTypes < ActiveRecord::Migration
  def self.up
    create_table :building_types do |t|
      t.boolean :active
      t.integer :position
      t.timestamps
    end

    BuildingType.create_translation_table! :name => :string
  end
  
  def self.down
    drop_table :building_types
    BuildingType.create_translation_table!
  end
end
