class Municipality < ActiveRecord::Base
  #attr_accessible :district_id, :city_id, :position
  cattr_reader :per_page
  @@per_page = 10

  translates :name, :description
  validate :name, :presence => true
  validate :district_id, :presence => true

  belongs_to :district
  has_many :cities

  default_scope :include => :translations
end

# == Schema Information
#
# Table name: municipalities
#
#  id          :integer(4)      not null, primary key
#  district_id :integer(4)
#  position    :integer(4)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

