class FixProjectDesc < ActiveRecord::Migration
  def self.up
    change_column(:project_translations, :description, :text)
    change_column(:project_translations, :aditional_description, :text)
  end

  def self.down
  end
end