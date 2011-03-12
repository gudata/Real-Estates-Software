class CreateFenceTypes < ActiveRecord::Migration
  def self.up
    create_table :fence_types do |t|
      t.boolean :active
      t.integer :position
      t.timestamps
    end

    FenceType.create_translation_table! :name => :string
  end
  
  def self.down
    drop_table :fence_types
    FenceType.drop_translation_table!
  end
end
