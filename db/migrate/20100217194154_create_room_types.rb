class CreateRoomTypes < ActiveRecord::Migration
  def self.up
    create_table :room_types do |t|
      t.boolean :active
      t.integer :position
      t.timestamps
    end

    RoomType.create_translation_table! :name => :string
  end
  
  def self.down
    drop_table :room_types
    RoomType.drop_translation_table!
  end
end
