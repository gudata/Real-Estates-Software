class CreateHeatingTypes < ActiveRecord::Migration
  def self.up
    create_table :heating_types do |t|
      t.boolean :active
      t.integer :position
      t.timestamps
    end

    HeatingType.create_translation_table! :name => :string
  end
  
  def self.down
    drop_table :heating_types
    HeatingType.drop_translation_table!
  end
end
