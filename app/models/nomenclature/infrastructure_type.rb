# == Schema Information
#
# Table name: infrastructure_types
#
#  id         :integer(4)      not null, primary key
#  active     :boolean(1)
#  position   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class InfrastructureType < ActiveRecord::Base
  translates :name
  default_scope :include => :translations
end
