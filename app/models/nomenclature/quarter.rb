# == Schema Information
#
# Table name: quarters
#
#  id         :integer(4)      not null, primary key
#  city_id    :integer(4)
#  position   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Quarter < ActiveRecord::Base
  #attr_accessible :district_id, :position
  cattr_reader :per_page
  @@per_page = 10
  
  translates :name
  validate :name, :presence => true
  validate :city_id, :presence => true

  belongs_to :city  

  default_scope :include => :translations
end
