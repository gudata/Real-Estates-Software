class CreateCountries < ActiveRecord::Migration
  def self.up
    create_table :countries do |t|
      t.integer :position
      t.timestamps
    end

    Country.create_translation_table! :name => :string
  end

  def self.down
    drop_table :countries
    Country.drop_translation_table!
  end
end
