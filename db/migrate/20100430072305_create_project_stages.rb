class CreateProjectStages < ActiveRecord::Migration
  def self.up
    create_table :project_stages do |t|
      t.boolean :active
      t.integer :position
      t.timestamps
    end

   ProjectStage.create_translation_table! :name => :string
  end
  
  def self.down
    drop_table :project_stages
    ProjectStage.drop_translation_table!
  end
end
