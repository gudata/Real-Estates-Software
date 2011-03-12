class CreateDistricts < ActiveRecord::Migration
  def self.up
    create_table :districts do |t|
      t.integer :country_id
      t.boolean :is_city
      t.timestamps
    end

    District.create_translation_table! :name => :string, :description => :text
    add_index(:districts, :country_id)
  end

  
  def self.down
    drop_table :districts
    District.drop_translation_table!
    remove_index(:districts, :country_id)
  end
end
