class CreateExposureTypes < ActiveRecord::Migration
  def self.up
    create_table :exposure_types do |t|
      t.boolean :active
      t.integer :position
      t.timestamps
    end

    ExposureType.create_translation_table! :name => :string
  end
  
  def self.down
    drop_table :exposure_types
    ExposureType.drop_translation_table!
  end
end
