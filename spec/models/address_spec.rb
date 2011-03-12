# == Schema Information
#
# Table name: addresses
#
#  id              :integer(4)      not null, primary key
#  country_id      :integer(4)
#  district_id     :integer(4)
#  municipality_id :integer(4)
#  city_id         :integer(4)
#  quarter_id      :integer(4)
#  street          :string(255)
#  number          :string(255)
#  entrance        :string(255)
#  floor           :integer(4)
#  apartment       :string(255)
#  lat             :float
#  lng             :float
#  created_at      :datetime
#  updated_at      :datetime
#  building        :string(255)
#  floor_type_id   :string(25)
#  street_type_id  :string(25)
#  description     :text
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AddressDocument do

  it "празен адрес" do
    a = AddressDocument.new
    a.should be_empty
  end

  it "Пълен адрес" do
    a = AddressDocument.new
    a.lat = "123123"
    a.should_not be_empty

    a = AddressDocument.new
    a.quarter_id = "123123"
    a.should_not be_empty

    a = AddressDocument.new
    a.street = "123123"
    a.should_not be_empty
  end
  
end
