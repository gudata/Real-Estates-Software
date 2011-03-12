class AddTeamIdToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :team_id, :integer
  end

  def self.down
    remove_column :users, :team_id
  end
end
