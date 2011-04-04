class CreateSpheres < ActiveRecord::Migration
  def self.up
    create_table :spheres do |t|
      t.boolean :active
      t.integer :position
      t.timestamps
    end

    Sphere.create_translation_table! :name => :string
#    add_index(:spheres, :position)
  end

  def self.down
    drop_table :spheres
#    remove_index(:spheres, :position)
    Sphere.drop_translation_table!
  end
end
