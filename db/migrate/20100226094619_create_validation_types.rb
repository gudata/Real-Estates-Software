class CreateValidationTypes < ActiveRecord::Migration
  def self.up
    create_table :validation_types do |t|
      t.string :name
      t.boolean :active
      t.integer :position
      t.timestamps
    end
  end
  
  def self.down
    drop_table :validation_types
  end
end
