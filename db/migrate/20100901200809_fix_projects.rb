class FixProjects < ActiveRecord::Migration
  def self.up
    Project.all.each{|p| p.save}

  end

  def self.down
  end
end