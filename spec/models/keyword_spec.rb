# == Schema Information
#
# Table name: keywords
#
#  id                :integer(4)      not null, primary key
#  tag               :string(255)
#  patern            :string(255)
#  as                :string(255)
#  active            :boolean(1)
#  validation_method :string(255)
#  values            :integer(4)
#  kind_of_search    :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

require 'spec_helper'

describe Keyword do
  context "Ключова дума спрямо тип имот" do

    before :each do
      
      @keyword1 = Keyword.create(
        :name => '..',
        :tag => 'tag',
        :as => 'asd..',
        :patern => 'patern'
      )

      @keyword2 = Keyword.create(
        :name => '..',
        :tag => 'tag',
        :as => 'asd..',
        :patern => 'patern'
      )
      @office = PropertyType.make(:office)
      @apartment = PropertyType.make(:apartment)
    end
    
    it "Правене на нова к.д. към тип имот" do
      @office.reload
      @keyword1.reload
      @keyword2.reload
      
      @keyword1.property_types << @office
      @keyword1.position(@office.id).should eql KeywordsPropertyType::INCREMENT

      @keyword2.property_types << @office
      @keyword2.position(@office.id).should eql KeywordsPropertyType::INCREMENT * 2

      @keyword1.property_types << @apartment

      @keyword1.position(@office.id).should eql KeywordsPropertyType::INCREMENT

    end

    it "Присвояване на кл. дума на тип имот" do
      @office.reload
      @keyword1.reload
      @keyword2.reload
      
      ap "#{__FILE__}: office keywords in start:"
      ap @office.keywords
      @office.keywords << @keyword1

      @keyword1.position(@office.id).should eql KeywordsPropertyType::INCREMENT
      ap "#{__FILE__}: office keywords:"
      ap @office.keywords
      @office.keywords.should have(1).keyword
      @keyword1.keywords_property_types.should have(1).property
      @keyword1.property_types.should have(1).property
      
      @office.keywords << @keyword2

      @office.keywords.should have(2).keywords
      @keyword2.property_types.should have(1).property
      @keyword2.position(@office.id).should eql KeywordsPropertyType::INCREMENT * 2
      @keyword2.keywords_property_types.should have(1).property

      
      @apartment.keywords << @keyword1

      @apartment.keywords(true).should have(1).keywords
      @keyword1.property_types(true).should have(2).properties
      @keyword1.keywords_property_types(true).should have(2).properties

      @keyword1.position(@apartment.id).should eql KeywordsPropertyType::INCREMENT

    end
  end
end
