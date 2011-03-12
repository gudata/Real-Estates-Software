# == Schema Information
#
# Table name: contacts_contact_categories
#
#  id                  :integer(4)      not null, primary key
#  contact_id          :integer(4)
#  contact_category_id :integer(4)
#  user_id             :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#

class ContactsContactCategory < ActiveRecord::Base
  belongs_to :contact
  belongs_to :contact_category
end