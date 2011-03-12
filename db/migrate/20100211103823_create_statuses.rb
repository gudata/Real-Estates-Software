class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.string :name
      t.boolean :hide_on_this_status
      t.integer :position
      t.timestamps
    end
    
    Status.create_translation_table! :name => :string
  end
  
  def self.down
    drop_table :statuses
    Status.drop_translation_table!
  end
end
