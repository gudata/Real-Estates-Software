# == Schema Information
#
# Table name: projects
#
#  id                            :integer(4)      not null, primary key
#  name                          :string(255)
#  contact_id                    :integer(4)
#  status_id                     :integer(4)
#  source_id                     :integer(4)
#  reference_point               :string(255)
#  property_category_location_id :integer(4)
#  user_id                       :integer(4)
#  team_id                       :integer(4)
#  contact_person                :string(255)
#  contact_person_phone          :string(255)
#  address_id                    :integer(4)
#  furnish_id                    :integer(4)
#  website                       :string(255)
#  start_date                    :date
#  finish_date                   :date
#  managment_fee                 :float
#  discount                      :float
#  brokerage                     :float
#  description                   :text
#  additional_description        :text
#  active                        :boolean(1)
#  project_stage_id              :integer(4)
#  created_at                    :datetime
#  updated_at                    :datetime
#  source_value                  :string(255)
#

require 'spec_helper'

describe Project do
  include AbilityHelperMethods
  include SellHelperMethods
  
#  before(:each) do
#    @contact = Contact.make
#    @user = User.make
#    @project = make_project(@user, @contact)
#    @keywords, @buy_values, @sell_values = keywords
#  end

end
