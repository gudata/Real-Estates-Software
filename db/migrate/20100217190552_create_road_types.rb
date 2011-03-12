class CreateRoadTypes < ActiveRecord::Migration
  def self.up
    create_table :road_types do |t|
      t.boolean :active
      t.integer :position
      t.timestamps
    end

    RoadType.create_translation_table! :name => :string
  end
  
  def self.down
    drop_table :road_types
    RoadType.drop_translation_table!
  end
end
