class AddTeamId2Sell < ActiveRecord::Migration
  def self.up
    add_column :sells, :team_id, :integer
  end

  def self.down
    remove_column :sells, :team_id
  end
end