class CreateContactsSpheres < ActiveRecord::Migration
  def self.up
    create_table :contacts_spheres do |t|
      t.integer :contact_id
      t.integer :sphere_id
      t.integer :user_id
      t.timestamps
    end

    add_index(:contacts_spheres, :contact_id)
    add_index(:contacts_spheres, :sphere_id)
    add_index(:contacts_spheres, :user_id)
  end

  def self.down
    remove_index(:contacts_spheres, :contact_id)
    remove_index(:contacts_spheres, :sphere_id)
    remove_index(:contacts_spheres, :user_id)
    drop_table :contacts_spheres
  end
end
