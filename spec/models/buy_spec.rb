require 'spec_helper'
require "machinist/mongoid"

describe SearchCriteria do

  context "Работа с Buy" do
    before(:each) do
      @buy = Buy.make

      @apartment = PropertyType.make(:apartment)
      @office = PropertyType.make(:office)
      
      @search_criteria_apartment = SearchCriteria.new(:property_type_id => @apartment.id)
      @search_criteria_office = SearchCriteria.new(:property_type_id => @office.id)
    end

    it "Една оферта търси може да има много related критерии" do
      @buy.search_criterias.should be_empty

      @buy.search_criterias << @search_criteria_apartment
      @buy.search_criterias << @search_criteria_office
      @buy.save
      
      founded = Buy.find(@buy.id)
      founded.search_criterias.should have(2).documents

    end
  end
  
end