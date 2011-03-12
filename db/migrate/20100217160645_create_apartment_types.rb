class CreateApartmentTypes < ActiveRecord::Migration
  def self.up
    create_table :apartment_types do |t|
      t.boolean :active
      t.integer :position
      t.timestamps
    end

    ApartmentType.create_translation_table! :name => :string
  end
  
  def self.down
    drop_table :apartment_types
    ApartmentType.drop_translation_table!
  end
end
