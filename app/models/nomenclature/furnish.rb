# == Schema Information
#
# Table name: furnishes
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Furnish < ActiveRecord::Base
  translates  :name
  default_scope :include => :translations
end
