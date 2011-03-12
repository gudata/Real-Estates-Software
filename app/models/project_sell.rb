# == Schema Information
#
# Table name: sells
#
#  id                            :integer(4)      not null, primary key
#  user_id                       :integer(4)
#  client_id                     :integer(4)
#  offer_type_id                 :integer(4)
#  property_type_id              :integer(4)
#  status_id                     :integer(4)
#  address_id                    :integer(4)
#  source_id                     :integer(4)
#  source_value                  :string(255)
#  mongo_document_id             :string(255)
#  property_category_location_id :integer(4)
#  project_id                    :integer(4)
#  project_building              :string(255)
#  project_entrance              :string(255)
#  project_floor                 :integer(4)
#  project_unit                  :string(255)
#  created_at                    :datetime
#  updated_at                    :datetime
#  team_id                       :integer(4)
#  co_owner_id                   :integer(4)
#  valid_to                      :date
#  canceled_until                :date
#  canceled_type_id              :string(255)
#

class ProjectSell < Sell
  set_table_name "sells"
  def initialize
    @sell = Sell.new()
  end
end
