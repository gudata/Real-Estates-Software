# == Schema Information
#
# Table name: contacts_spheres
#
#  id         :integer(4)      not null, primary key
#  contact_id :integer(4)
#  sphere_id  :integer(4)
#  user_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class ContactsSphere < ActiveRecord::Base
  belongs_to :contact
  belongs_to :sphere
end

# == Schema Information
#
# Table name: contacts_spheres
#
#  id         :integer(4)      not null, primary key
#  contact_id :integer(4)
#  sphere_id  :integer(4)
#  user_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

