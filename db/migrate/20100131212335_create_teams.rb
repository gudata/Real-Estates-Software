class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.boolean :active
      t.timestamps
    end

    Team.create_translation_table! :name => :string, :description => :text
  end
  
  def self.down
    drop_table :teams
    Team.drop_translation_table!
  end
end
