class AddMainCity < ActiveRecord::Migration
  def self.up
    add_column :cities, :main, :boolean, :default => false
    add_index('cities', [:main], :unique => false)
  end

  def self.down
    remove_column :cities, :main
  end
end