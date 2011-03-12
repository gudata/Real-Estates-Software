class AddDefaultStatus < ActiveRecord::Migration
  def self.up
    add_column :statuses, :default, :boolean
  end

  def self.down
    remove_column :statuses, :default
  end
end