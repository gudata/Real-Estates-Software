class CreateContactsUsers < ActiveRecord::Migration
  def self.up
    create_table :contacts_users do |t|
      t.integer :contact_id
      t.integer :user_id
      t.boolean :is_client
      t.timestamps
    end

    add_index(:contacts_users, [:contact_id, :user_id])
  end

  def self.down
    remove_index(:contacts_users, [:contact_id, :user_id])
    drop_table :contacts_users
  end
end
