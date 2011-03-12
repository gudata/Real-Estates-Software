# == Schema Information
#
# Table name: project_stages
#
#  id         :integer(4)      not null, primary key
#  active     :boolean(1)
#  position   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class ProjectStage < ActiveRecord::Base
  translates :name

  has_many :projects
end
