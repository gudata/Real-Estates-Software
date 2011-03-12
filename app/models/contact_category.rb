# == Schema Information
#
# Table name: contact_categories
#
#  id       :integer(4)      not null, primary key
#  active   :boolean(1)
#  position :integer(4)
#

class ContactCategory <  ActiveRecord::Base
  translates :name
  validate :name, :presence => true

  has_many :contacts_contact_categories
  has_many :contacts, :through => :contacts_contact_categories

  default_scope :include => :translations
end

# == Schema Information
#
# Table name: contact_categories
#
#  id       :integer(4)      not null, primary key
#  active   :boolean(1)
#  position :integer(4)
#

