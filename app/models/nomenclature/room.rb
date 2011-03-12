# == Schema Information
#
# Table name: rooms
#
#  id               :integer(4)      not null, primary key
#  sell_id          :integer(4)
#  room_type_id     :integer(4)
#  property_type_id :integer(4)
#  area             :float
#  condition        :string(255)
#  balcony          :boolean(1)
#  exposure_type_id :integer(4)
#  created_at       :datetime
#  updated_at       :datetime
#

class Room < ActiveRecord::Base
  translates :description
  belongs_to :room_type
  belongs_to :exposure_type

  default_scope :include => [:translations, :room_type, :exposure_type]

  validates_presence_of :room_type_id
  validates_numericality_of :area, :allow_nil => true
end
