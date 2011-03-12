# == Schema Information
#
# Table name: exposure_types
#
#  id         :integer(4)      not null, primary key
#  active     :boolean(1)
#  position   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class ExposureType < ActiveRecord::Base
  translates :name
  validate :name, :presence => true

  has_one :room  
  default_scope :include => :translations
end
