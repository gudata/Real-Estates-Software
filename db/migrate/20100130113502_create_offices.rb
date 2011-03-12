class CreateOffices < ActiveRecord::Migration
  def self.up
    create_table :offices do |t|
      t.integer :address_id
      t.string :mobile_phone
      t.string :phone
      t.string :fax
      t.timestamps
    end

    Office.create_translation_table! :name => :string, :description => :text
    add_index(:offices, :address_id)
  end
  
  def self.down
    drop_table :offices
    remove_index(:offices, :address_id)
    Office.drop_translation_table
  end
end
