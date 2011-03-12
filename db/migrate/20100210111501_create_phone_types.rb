class CreatePhoneTypes < ActiveRecord::Migration
  def self.up
    create_table :phone_types do |t|
      t.boolean :active
      t.integer :position
      t.timestamps
    end

    PhoneType.create_translation_table! :name => :string
  end

  def self.down
    drop_table :phone_types
    PhoneType.drop_translation_table!
  end
end
