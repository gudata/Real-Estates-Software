class AddCountryIcon < ActiveRecord::Migration
  def self.up
    add_column :countries, :icon, :string
  end

  def self.down
    remove_column :sells, :icon
  end
end