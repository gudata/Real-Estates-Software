# == Schema Information
#
# Table name: building_types
#
#  id         :integer(4)      not null, primary key
#  active     :boolean(1)
#  position   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class BuildingType < ActiveRecord::Base
  translates :name
  validate :name, :presence => true
  default_scope :include => :translations
end
