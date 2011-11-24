require 'app/uploaders/icon_uploader'
#require 'carrierwave/orm/activerecord'

# == Schema Information
#
# Table name: countries
#
#  id         :integer(4)      not null, primary key
#  position   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Country < ActiveRecord::Base
  #  attr_accessible :position
  translates :name

  validate :name, :presence => true

  has_many :districts
  has_many :addresses
  has_one :nationality, :class_name => "Contact"

  default_scope :include => :translations

  #field :icon
  mount_uploader :icon, IconUploader

end
