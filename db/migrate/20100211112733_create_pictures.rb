class CreatePictures < ActiveRecord::Migration
  def self.up
    create_table :pictures do |t|
      t.string :name
      t.string :description
      t.string :picture_file_name
      t.string :picture_content_type
      t.string :picture_file_size
      t.string :imagable_type
      t.integer :imagable_id
      t.timestamps
    end
    Picture.create_translation_table! :name => :string, :description => :string
    add_index(:pictures, [:imagable_type, :imagable_id])
  end
  
  def self.down
    drop_table :pictures
    remove_index(:pictures, [:imagable_type, :imagable_id])
    Picture.drop_translation_table!
  end
end
