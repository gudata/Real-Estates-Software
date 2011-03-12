class CreatePropertyTypes < ActiveRecord::Migration
  def self.up
    create_table :property_types do |t|
      t.boolean :active
      t.integer :position
      t.timestamps
    end

    PropertyType.create_translation_table! :name => :string
    add_index(:property_types, :position)
  end
  
  def self.down
    drop_table :property_types
    remove_index(:property_types, :position)
    PropertyType.drop_translation_table!
  end
end
