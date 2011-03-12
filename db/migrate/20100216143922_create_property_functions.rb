class CreatePropertyFunctions < ActiveRecord::Migration
  def self.up
    create_table :property_functions do |t|
      t.boolean :active
      t.integer :position
      t.timestamps
    end

    PropertyFunction.create_translation_table! :name => :string
  end
  
  def self.down
    drop_table :property_functions
    PropertyFunction.drop_translation_table!
  end
end
