class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.boolean :is_company
      t.integer :added_by
      t.integer :address_id
      t.integer :nationality_id
      t.boolean :important
      t.string :web
      t.string :person_first_name
      t.string :person_last_name
      t.string :person_middle_name
      t.string :person_employment
      t.string :person_position
      t.string :company_name
      t.string :company_branch
      t.string :bank_account
      t.string :iban
      t.string :mol_first_name
      t.string :mol_last_name
      t.string :mol_phone
      t.string :picture_file_name
      t.string :picture_content_type
      t.integer :picture_file_size
      t.integer :projects_count, :default => 0
      t.integer :sells_count, :default => 0
      t.string :key
      t.timestamps
    end

    Contact.create_translation_table! :description => :text
    add_index(:contacts, :key)
    add_index(:contacts, :address_id)
    add_index(:contacts, :picture_file_name)
  end

  def self.down
    remove_index(:contacts, :key)
    remove_index(:contacts, :removeress_id)
    remove_index(:contacts, :picture_file_name)
    drop_table :contacts
    Contact.drop_translation_table!
  end
end
