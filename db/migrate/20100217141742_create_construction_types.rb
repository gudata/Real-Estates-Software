class CreateConstructionTypes < ActiveRecord::Migration
  def self.up
    create_table :construction_types do |t|
      t.boolean :active
      t.integer :position
      t.timestamps
    end

    ConstructionType.create_translation_table! :name => :string
  end
  
  def self.down
    drop_table :construction_types
    ConstructionType.drop_translation_table!
  end
end
