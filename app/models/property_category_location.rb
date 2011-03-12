# == Schema Information
#
# Table name: property_category_locations
#
#  id         :integer(4)      not null, primary key
#  active     :boolean(1)
#  position   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class PropertyCategoryLocation < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 10
  translates :name

  has_many :sells
  has_many :projects

  default_scope :include => :translations
end
