class AddActiveToOffice < ActiveRecord::Migration
  def self.up
    add_column :offices, :active, :boolean
  end

  def self.down
    remove_column :offices, :active
  end
end
