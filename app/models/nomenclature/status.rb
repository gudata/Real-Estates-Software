# == Schema Information
#
# Table name: statuses
#
#  id                  :integer(4)      not null, primary key
#  name                :string(255)
#  hide_on_this_status :boolean(1)
#  position            :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#  default             :boolean(1)
#

# This status is for the Offers Buy and Sell
#   First information
#   Contract
#   Canceled
#   etc..
# There is another status BuyStatus which is completly different thing
#   Offered
#   Visited
#   Canceled
#
class Status < ActiveRecord::Base
  translates :name  
  has_one :sell
  default_scope :include => :translations
  scope :default_statuses, where(:default => true)

  # маркираните с този статус оферти са видими
  scope :active, where(:hide_on_this_status => false)

end
