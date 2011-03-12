=begin

Warning - enterprise ruby code !

=end

require 'spec_helper'
# require "machinist/mongoid"
include AbilityHelperMethods
include SellHelperMethods

describe MatchingSell do
  context "Търсене с критерия" do
    before(:each) do
      Buy.delete_all
      SellDocument.delete_all

      @user = make_user
      @contact = make_contact(@user)
      @registered = Status.make(:name => 'Регистрирана или друга')
      @keywords, @keywords_buy_values, @keywords_sell_values  = keywords
      @sell_offer_type, @buy_offer_type = get_buy_sell_offer_types

      # оферти продава .......

      @office_property_type = PropertyType.make(:office)
      @apartment_property_type = PropertyType.make(:apartment)

      @bulgaria = Country.make(:name => "Bulgaria")
      @sofia = Address.create(
        :country_id => @bulgaria,
        :district_id => District.make(:name => "Sofia", :country_id => @bulgaria.id),
        :street => "Bojcho Ognianov",
        :number => "4"
      )
      @plovdiv = Address.create(
        :country_id => @bulgaria,
        :district_id => District.make(:name => "Plovdiv", :country_id => @bulgaria.id),
        :street => "Botev",
        :number => "14"
      )

      @sell_apartment = sell_with_keywords(@user, @contact, @apartment_property_type,
        @registered, @sell_offer_type, @keywords, @keywords_sell_values, @sofia)
      @sell_office = sell_with_keywords(@user, @contact, @office_property_type,
        @registered, @sell_offer_type, @keywords, @keywords_sell_values, @plovdiv)
      
      # оферти търси ...........
      
      @buy = Buy.make(
        :contact_id => @contact.id,
        :user_id => @user.id,
        :created_by_user_id => @user.id,
        :status_id => @registered.id,
        :offer_type_id => @buy_offer_type.id
      )

      # прикачане на критерии към оферти търси
      @apartment_search_criteria = make_search_criteria({
          :property_type => @sell_apartment.property_type,
          :keywords => @sell_apartment.keywords,
          :keywords_buy_values => @keywords_buy_values,
        })
      @office_search_criteria = make_search_criteria({
          :property_type => @sell_office.property_type,
          :keywords => @sell_office.keywords,
          :keywords_buy_values => @keywords_buy_values,
        })

      @buy.search_criterias << @apartment_search_criteria
      @buy.search_criterias << @office_search_criteria
      @buy.save
    end

    it "Хеша за търсена по адресите работи " do
#      ap "starting with"
#      ap @sofia

      no_address_hash_for_searching = @buy.hash_for_searching
#      ap no_address_hash_for_searching
      no_address_hash_for_searching.should_not have_key("$in")

      @buy.address_documents << AddressDocument.new.init_from(@sofia)
      @buy.address_documents << AddressDocument.new.init_from(@plovdiv)

      @buy.save
#      ap @buy.address_documents

      @buy.address_documents.should have(2).addresses
      @buy.address_documents.first.country_id.should eql(@sofia.country_id)

      hash_for_searching = @buy.hash_for_searching
#      ap hash_for_searching
      hash_for_searching.should have_key(:offer_type_id)
      hash_for_searching.should have_key(:status_id)
    end

    it "SearchCriteria връща правилен хеш за търсене" do
      @office_search_criteria.buy.should be_kind_of Buy

      hash_for_searching = @office_search_criteria.hash_for_searching
      hash_for_searching.should have_key(:property_type_id)
    end
    
    
    it "Правилно са се събрали ключовете от критерията с терми" do
      matching_sell = MatchingSell.new
      @office_search_criteria.buy.should be_kind_of Buy

      hash_for_searching = @office_search_criteria.hash_for_searching

      hash_for_searching.should have_key(:property_type_id)

      # Трябва ни sell оферта
      # Трябва да и сложим трите вида терми
      # трябва buy-а да им даде стойности по тези три вида терми
      #
      # трябва да мачнем по всяка от тях самостоятелно
    end
    
    it "Попълва MatchingSell от SearchCriteria (купува -> продава)" do
      @buy.search_criterias.should have(2).criteria

      matching_sell = MatchingSell.new

      matching_sell << @office_search_criteria

      #      ap matching_sell.sell_documents

      matching_sell.first.selector.should have_key(:property_type_id)
      matching_sell.first.selector.should have_key(:status_id)
      matching_sell.first.selector.should have_key(:offer_type_id)
      matching_sell.first.selector[:property_type_id].should_not be_blank
      matching_sell.first.selector[:status_id].should_not be_blank
      matching_sell.first.selector[:offer_type_id].should_not be_blank

      matching_sell.first.selector[:property_type_id].should eql @office_property_type.id
      matching_sell.first.selector[:status_id].should eql @registered.id
      matching_sell.first.selector[:offer_type_id].should eql @buy_offer_type.oposite_offer_type_id

      matching_sell.first.entries.should have(1).element

      matching_sell << @apartment_search_criteria

      matching_sell.last.selector[:property_type_id].should eql @apartment_property_type.id
      matching_sell.last.selector[:offer_type_id].should eql @buy_offer_type.oposite_offer_type_id
      matching_sell.last.selector[:status_id].should eql @registered.id
      matching_sell.last.entries.should have(1).element

      matching_sell.merged_results.entries.should have(2).elements
    end
    
    it "Попълва MatchingSell от Buy (купува -> продава)" do
      @buy.search_criterias.should have(2).criteria

      matching_sell = MatchingSell.new

      matching_sell << @buy

      matching_sell.first.entries.should have(1).element
      matching_sell.last.entries.should have(1).element


      matching_sell.merged_results.entries.should have(2).elements
    end
    
  end
end

__END__
s = SellDocument.criteria.where(
  :terms =>
    {"$elemMatch" => {:tag => 'furniture', :value => "2"}}
)
db.sell_documents.find({ "terms" : {"$elemMatch" : {"tag" : "furniture", "value" : "2" }}})

#"$all" =>
s = SellDocument.criteria.where(
  :terms.all =>
    [
    {"$elemMatch" => {:tag => 'furniture', :value => 1}},
    {"$elemMatch" => {:tag => 'phone', :value => 1}}
  ]
)
s.entries
db.sell_documents.find({"terms":[{"$elemMatch":{"tag":"furniture","value":"2"}},{"$elemMatch":{"tag":"phone","value":"2"}}]})

s = SellDocument.criteria.where(
  :terms.all =>
    [
    {"$elemMatch" => {:tag => 'phone', :value => 1}},
    {"$elemMatch" => {:tag => 'infrastructure', :values => {"$all" =>  ["4", "5"]}}},
  ]
)
s.entries

s = SellDocument.criteria.where(
  :terms.all =>
    [
    {"$elemMatch" => {:tag => 'phone', :value => 1}},
    {"$elemMatch" => {:tag => 'price', :value =>{"$gte" => 90, "$lte" => 190}}},
    {"$elemMatch" => {:tag => 'infrastructure', :values => {"$all" =>  ["4", "5"]}}},
  ]
)
s.entries

ap SellDocument.where(:sell_id => "120").entries.first.terms

# търсене по адрес

s = SellDocument.where(
  {
    :status_id => "1",
    :offer_type_id => "3",
    :address_documents.all => [
      "$elemMatch" => {"district_id" => "1", "country_id" => "1",}
    ]
  }
)
s.entries




