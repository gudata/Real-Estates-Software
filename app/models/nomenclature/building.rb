# == Schema Information
#
# Table name: buildings
#
#  id               :integer(4)      not null, primary key
#  building_type_id :integer(4)
#  property_type_id :integer(4)
#  area             :float
#  created_at       :datetime
#  updated_at       :datetime
#

# не го знам къде се използва
class Building < ActiveRecord::Base
  translates :description
  default_scope :include => :translations
end

