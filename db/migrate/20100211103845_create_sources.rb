class CreateSources < ActiveRecord::Migration
  def self.up
    create_table :sources do |t|
      t.string :name
      t.timestamps
    end
    
    Source.create_translation_table! :name => :string
  end
  
  def self.down
    drop_table :sources
    Source.drop_translation_table!
  end
end
