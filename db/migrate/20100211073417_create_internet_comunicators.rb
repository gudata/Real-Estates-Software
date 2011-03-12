class CreateInternetComunicators < ActiveRecord::Migration
  def self.up
    create_table :internet_comunicators do |t|
      t.string :value
      t.integer :internet_comunicator_type_id
      t.integer :contact_id
      t.timestamps
    end

    add_index(:internet_comunicators, :internet_comunicator_type_id)
    add_index(:internet_comunicators, :contact_id)
  end

  def self.down
    remove_index(:internet_comunicators, :internet_comunicator_type_id)
    remove_index(:internet_comunicators, :contact_id)
    drop_table :internet_comunicators
  end
end
