# == Schema Information
#
# Table name: districts
#
#  id         :integer(4)      not null, primary key
#  country_id :integer(4)
#  is_city    :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

class District < ActiveRecord::Base
#  attr_accessible :country_id, :is_city, :position
  cattr_reader :per_page
  @@per_page = 10

  translates :name, :description
  validate :name, :presence => true
  validate :country_id, :presence => true

  belongs_to :country
  has_many :municipalities

  default_scope :include => :translations, :order => "district_translations.name asc"
end
