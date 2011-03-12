# == Schema Information
#
# Table name: property_locations
#
#  id         :integer(4)      not null, primary key
#  active     :boolean(1)
#  position   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class PropertyLocation < ActiveRecord::Base
  cattr_reader :paer_page
  @@per_page = 10
  translates :name
  
  validate :name, :presence => true
  default_scope :include => :translations
end
