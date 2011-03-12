class CreateFurnishes < ActiveRecord::Migration
  def self.up
    create_table :furnishes do |t|
      t.string :name
      t.timestamps
    end
    
    Furnish.create_translation_table! :name => :string
  end
  
  def self.down
    drop_table :furnishes
    Furnish.drop_translation_table!
  end
end
