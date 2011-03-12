class CreateMunicipalities < ActiveRecord::Migration
  def self.up
    create_table :municipalities do |t|
      t.integer :district_id
      t.integer :position
      t.text :description
      t.timestamps
    end

    Municipality.create_translation_table! :name => :string, :description => :text
    add_index(:municipalities, :district_id)
  end


  
  def self.down
    remove_table :municipalities
    remove_index(:municipalities, :district_id)
    Municipality.drop_translation_table
  end
end
