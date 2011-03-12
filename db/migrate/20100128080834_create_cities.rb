class CreateCities < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.belongs_to :district
      t.belongs_to :municipality
      t.string  :place_type
      t.integer :kind      # 1 -гр./град/, 3 -с./село/
      t.integer :position
      t.integer :ekatte
      t.timestamps
    end

    City.create_translation_table! :name => :string, :description => :text
    add_index(:cities, :municipality_id)
    add_index(:cities, :district_id)
  end

  
  def self.down
    drop_table :cities
    remove_index(:cities, :municipality_id)
    remove_index(:cities, :district_id)
    City.drop_translation_table!
  end
end
