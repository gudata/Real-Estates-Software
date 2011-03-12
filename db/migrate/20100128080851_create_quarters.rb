class CreateQuarters < ActiveRecord::Migration
  def self.up
    create_table :quarters do |t|
      t.integer :city_id
      t.integer :position
      t.timestamps
    end

    Quarter.create_translation_table! :name => :string
    add_index(:quarters, :city_id)
  end


  def self.down
    drop_table :quarters
    remove_index(:quarters, :city_id)
    Quarters.drop_translation_table!
  end
end
