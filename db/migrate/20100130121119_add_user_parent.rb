class AddUserParent < ActiveRecord::Migration
  def self.up
    add_column :users, :user_id, :integer
  end

  def self.down
    remove_column :role, :user_id
  end
end
