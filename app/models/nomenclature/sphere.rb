class Sphere <  ActiveRecord::Base
  translates :name
  validate :name, :presence => true

  has_many :contacts_speheres
  has_many :contacts, :through => :contacts_speheres

  default_scope :include => :translations
end

# == Schema Information
#
# Table name: spheres
#
#  id         :integer(4)      not null, primary key
#  active     :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

