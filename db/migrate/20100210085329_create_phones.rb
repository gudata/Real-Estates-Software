class CreatePhones < ActiveRecord::Migration
  def self.up
    create_table :phones do |t|
      t.string :number
      t.string :number_clean
      t.integer :phone_type_id
      t.integer :contact_id
      t.timestamps
    end

    add_index(:phones, :phone_type_id)
    add_index(:phones, :contact_id)
    
    add_index(:phones, :number_clean)
  end
  
  def self.down
    drop_table :phones
  end
end
