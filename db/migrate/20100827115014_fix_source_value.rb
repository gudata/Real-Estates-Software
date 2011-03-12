class FixSourceValue < ActiveRecord::Migration
  def self.up
    remove_column :projects, :source_value
    add_column :projects, :source_value, :string
  end

  def self.down
    remove_column :projects, :source_value
    add_column :projects, :source_value, :integer
  end
end
