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

      t1 = Term.new(:name => "1", :position => 1, :tag => "price", :value => 1)
      @search_criteria_office.terms << t1
      @search_criteria_office.save
      seach_criteria = Buy.find(@buy.id).search_criterias.find(@search_criteria_office.id)
      seach_criteria.terms.should have(1).terms

      t2 = Term.new(:name => "2", :position => 3, :tag => "area", :value => 31)
      @search_criteria_office.terms << [t2]
      @search_criteria_office.save
      seach_criteria = Buy.find(@buy.id).search_criterias.find(@search_criteria_office.id)
      seach_criteria.terms.should have(2).terms

      ap "Terms:"
      ap @search_criteria_office.terms
#      @search_criteria_office.terms.destroy_all
      @search_criteria_office.terms.delete_all
      @search_criteria_office.terms = []
#      @search_criteria_office.terms.clear
      ap "Terms after delete:"
      ap @search_criteria_office.terms
#      @search_criteria_office.terms.each {|t| t.delete; }
      #      ap @search_criteria_office.terms
      @search_criteria_office.save
      
      seach_criteria = Buy.find(@buy.id).search_criterias.find(@search_criteria_office.id)
      ap "Terms after reload:"
      ap seach_criteria.terms
      seach_criteria.terms.should have(0).terms


#      @search_criteria_office.terms << t2
      @search_criteria_office.terms.build(t2.attributes)
      @search_criteria_office.save
      seach_criteria = Buy.find(@buy.id).search_criterias.find(@search_criteria_office.id)
      seach_criteria.terms.should have(1).terms
      
    end

  end
end

__END__

s.terms = [t1]
s.save
b.search_criterias.first.terms

s.update_attributes(params)
b.search_criterias.first.terms

b.search_criterias.first.update_attributes(params)
b.search_criterias.first.terms

b.search_criterias.first.update_attributes({
    :property_type_id => 2,
    :terms => [
      Term.new(:name => "2", :position => 3, :tag => "area", :value => 31)
    ]
  })

b.search_criterias.first.update_attributes({
    :property_type_id => 2,
    :terms => [
      t1
    ]
  })

