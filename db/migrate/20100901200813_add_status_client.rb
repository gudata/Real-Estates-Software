class AddStatusClient < ActiveRecord::Migration
  def self.up
    add_column :statuses, :client_visible, :boolean, :default => false
  end

  def self.down
    remove_column :statuses, :client_visible
  end
end