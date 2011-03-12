class CreateContactsContactCategories < ActiveRecord::Migration
  def self.up
    create_table :contacts_contact_categories do |t|
      t.integer :contact_id
      t.integer :contact_category_id
      t.integer :user_id
      t.timestamps
    end

    add_index(:contacts_contact_categories, :contact_id)
    add_index(:contacts_contact_categories, :contact_category_id)
    add_index(:contacts_contact_categories, :user_id)
  end

  def self.down
    remove_index(:contacts_contact_categories, :contact_id)
    remove_index(:contacts_contact_categories, :contact_category_id)
    remove_index(:contacts_contact_categories, :user_id)
    drop_table :contacts_contact_categories
  end
end
