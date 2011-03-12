class AddOfficeIdToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :office_id, :integer
  end

  def self.down
    remove_column :users, :office_id
  end
end
