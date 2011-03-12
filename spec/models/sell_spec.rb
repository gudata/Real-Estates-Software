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

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Sell do
  include AbilityHelperMethods
  include SellHelperMethods

  before :all do
    SellDocument.delete_all
  end

  before(:each) do
    @contact = Contact.make
    @user = User.make
    @property_type = PropertyType.make(:apartment)
    @registered = Status.make(:name => 'Регистрирана или друга')
    @sell_offer_type, @buy_offer_type = get_buy_sell_offer_types
    @keywords, @buy_values, @sell_values = keywords

    @sell = sell_with_keywords(@user, @contact, @property_type,
      @registered, @sell_offer_type, @keywords, @sell_values, Address.make)
  end

  it "За всяка оферта продава трябва да има keywords със стойности" do
    key_values = {}
    @sell.keywords_sells.collect do |sell_keyword|
      key_values[sell_keyword.keyword.tag] = {
        :value => sell_keyword.value,
        :tag => sell_keyword.keyword.tag,
        :name => sell_keyword.keyword.name,
        :patern => sell_keyword.keyword.patern
      }
    end
      
    @sell.keywords.should be_kind_of(Array)
    @sell.keywords.should_not be_empty

    key_values.each_key do |key|
      
      key_values[key][:value].should eql(@sell_values[key])
    end

  end
end
