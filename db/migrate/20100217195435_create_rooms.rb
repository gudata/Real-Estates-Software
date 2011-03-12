class CreateRooms < ActiveRecord::Migration
  def self.up
    create_table  :rooms do |t|
      t.integer   :sell_id
      t.integer   :room_type_id
      t.integer   :property_type_id
      t.float     :area
      t.string    :condition
      t.boolean   :balcony
      t.integer   :exposure_type_id
      t.timestamps
    end

    Room.create_translation_table! :description => :text
    add_index(:rooms, :room_type_id)
  end
  
  def self.down
    drop_table :rooms
    remove_index(:rooms, :room_type_id)
    Room.create_translation_table!
  end
end
