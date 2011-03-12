# == Schema Information
#
# Table name: phone_types
#
#  id         :integer(4)      not null, primary key
#  active     :boolean(1)
#  position   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class PhoneType < ActiveRecord::Base
  translates :name
  has_one :phone

  default_scope :include => :translations
end
