# == Schema Information
#
# Table name: sources
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Source < ActiveRecord::Base
  translates  :name
  has_one :sell
  default_scope :include => :translations
end
