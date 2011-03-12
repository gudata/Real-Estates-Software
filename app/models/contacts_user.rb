# == Schema Information
#
# Table name: contacts_users
#
#  id         :integer(4)      not null, primary key
#  contact_id :integer(4)
#  user_id    :integer(4)
#  is_client  :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

class ContactsUser < ActiveRecord::Base
  belongs_to :contact
  belongs_to :user  
end