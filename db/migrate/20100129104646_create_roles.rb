class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name
      t.integer :ident
      
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      
      t.timestamps
    end
    
    Role.create_translation_table! :name => :string
    add_index(:roles, [:parent_id, :lft, :rgt])
  end
  
  def self.down
    drop_table :roles
    remove_index(:roles, [:parent_id, :lft, :rgt])
    Role.drop_translation_table
  end
end
