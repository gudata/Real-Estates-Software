class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.integer :country_id
      t.integer :district_id
      t.integer :municipality_id
      t.integer :city_id
      t.integer :quarter_id
      t.string :street
      t.string :number
      t.string :entrance
      t.integer :floor
      t.string :apartment
      t.float   :lat
      t.float   :lng      
      t.timestamps
    end

    add_index(:addresses, :country_id)
    add_index(:addresses, :district_id)
    add_index(:addresses, :municipality_id)
    add_index(:addresses, :quarter_id)
    add_index(:addresses, :city_id)
    add_index(:addresses, [:street, :number])
    add_index(:addresses, [:lat, :lng])
  end

  def self.down
    remove_index(:addresses, :country_id)
    remove_index(:addresses, :district_id)
    remove_index(:addresses, :municipality_id)
    remove_index(:addresses, :quarter_id)
    remove_index(:addresses, [:street, :number])
    remove_index(:addresses, [:lat, :lng])
    drop_table :addresses
  end
end
