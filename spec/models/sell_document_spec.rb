require 'spec_helper'
require "machinist/mongoid"

describe SellDocument do
  context "Работа с Sell" do
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
      @keywords, @keywords_buy_values, @keywords_sell_values  = keywords
      
      @sell = sell_with_keywords(@user, @contact, @property_type, 
        @registered, @sell_offer_type, @keywords, @keywords_sell_values, Address.make)

    end

    it "трябва да обновява sell документа" do
      beast_number = 666
      @sell.status_id = beast_number
      @sell.save
      sell_document = SellDocument.find(@sell.mongo_document_id)
      sell_document.status_id.should eql beast_number.to_s
      sell_document.address_document.country_id.should eql(@sell.address.country_id)
      
      sell_document.status_id.should eql beast_number.to_s

      SellDocument.where(:sell_id => @sell.id).count.should eql(1)
      @sell.save
      SellDocument.where(:sell_id => @sell.id).count.should eql(1)
    end

    it "Взима Sell документ и съответния SellDocument трябва да бъде изтрит" do
      old_sell_document = SellDocument.find(@sell.mongo_document_id)
      @sell.destroy
      lambda {
        sell_document = SellDocument.find(old_sell_document.id)
      }.should raise_exception Mongoid::Errors::DocumentNotFound
    end
    
    it "Взима Sell документ и го запазва като SellDocument" do
      lambda {
        # sell-a е вече направен, така че тестваме дали са се пуснали call-back after/save/destroy
        sell_document = SellDocument.find(@sell.mongo_document_id)
        sell_document.user_id.should eql @user.id
        sell_document.property_type_id.should eql @sell.property_type_id
        sell_document.client_id.should eql @sell.client_id
        sell_document.contact_key.should eql @sell.contact_key
        sell_document.sell_id.should eql @sell.id
        sell_document.offer_type_id.should eql @sell.offer_type_id
        sell_document.status_id.should eql @sell.status_id
        sell_document.source_id.should eql @sell.source_id
        sell_document.source_value.should eql @sell.source_value
        sell_document.property_category_location_id.should eql @sell.property_category_location_id
        sell_document.country_id.should eql @sell.address.country_id
        sell_document.discrict_id.should eql @sell.address.district_id
        sell_document.municipality_id.should eql @sell.address.municipality_id
        sell_document.quarter_id.should eql @sell.address.quarter_id
        #    it "Слагането на keywords за Sell в SellDocument" do
        sell_document.street.should eql @sell.address.street
      }.should_not raise_exception Mongoid::Errors::DocumentNotFound
    
    end
    
    it "Слагането на keywords в SellDocument" do
      # в before(:each)-а би трябвало да сме направили и монговски документ.

      @sell.keywords_sells.should have(@keywords.size).keyword_sells
      @sell.sell_document.terms.should have(@keywords.size).terms
      @sell.sell_document.terms.should have(@sell.keywords_sells.size).terms

      # ще съберем таг-а на кл. дума и нейната стойност в хеш за по-лесно сравняване
      key_values = {}
      @sell.keywords_sells.collect do |sell_keyword|
        key_values[sell_keyword.keyword.tag] = {
          :artefact_kind_of_search => sell_keyword.keyword.kind_of_search,
          :value => sell_keyword.value,
          :tag => sell_keyword.keyword.tag,
          :name => sell_keyword.keyword.name,
          :patern => sell_keyword.keyword.patern
        }
      end
    
      @sell.sell_document.terms.each do |term|
        case key_values[term.tag][:artefact_kind_of_search]
        when 'multiple'
          term.values.join(",").should eql(key_values[term.tag][:value])
          term.value.should be_nil
        else
          term.value.should eql(key_values[term.tag][:value])
          term.values.should be_nil
        end
        term.tag.should eql(key_values[term.tag][:tag])
        term.name.should eql(key_values[term.tag][:name])
        term.patern.should eql(key_values[term.tag][:patern])
      end

      tag = @sell.sell_document.terms.last.tag
      @sell.sell_document.term(tag).tag.should eql(tag)
    end
  end

  
end