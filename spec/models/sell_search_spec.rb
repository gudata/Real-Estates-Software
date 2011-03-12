require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Sell do

  before :all do
    @buy_offer_type = OfferType.make()
    @sell_offer_type = OfferType.make(:oposite_offer_type_id => @buy_offer_type.id)
    @buy_offer_type.oposite_offer_type_id = @sell_offer_type.id
    @buy_offer_type.save

    @full_search_params = {
      :number => "12",
      :status_id => "2",
      :offer_type_id => @buy_offer_type.id,
      :property_type_id => "2",
      :address_documents => [
        {
          :municipality_id => "2",
          :city_id => "2",
        }
      ],
      :order_fields => {
        :city_id => SellSearch::SORT_KEYS[:asc],
        :created_at => SellSearch::SORT_KEYS[:desc],
        :price => SellSearch::SORT_KEYS[:asc],
      },
      :price_from => "2",
      :price_to => "20",
      :area_from => "11",
      :area_to => "12",
      :team_id => "2",
      :user_id => "12"
    }
  end 

  it "Инициализира се правилно с параметрите" do
    sell_search = SellSearch.new(@full_search_params)

    SellSearch.search_attributes.each do |key|
      sell_search.instance_variable_get(:"@#{key}").should eql @full_search_params[key]
    end
  end
  
  it "Когато се търси нищо, селектора е празен" do
    sell_search = SellSearch.new({})

    sell_search.sell_documents.selector.should be_empty
  end

  it "Тестване на различни параметери" do

    sell_search = SellSearch.new(@full_search_params)

    sell_search.sell_documents.selector.should have_key(:offer_type_id)
    # понеже имаме номер нямаме статус поле
    sell_search.sell_documents.selector.should_not have_key(:status_id)

    sell_search.sell_documents.selector.should have_key(:property_type_id)
    sell_search.sell_documents.selector[:offer_type_id].should eql @buy_offer_type.id

    sell_search.sell_documents.selector.should have_key(:terms)
    sell_search.sell_documents.selector[:terms].should have_key("$all")
    sell_search.sell_documents.selector[:terms]["$all"].should have(2).elements

    #    ap sell_search.sell_documents.selector
    sell_search.sell_documents.selector.should have_key("$or")
    sell_search.sell_documents.selector["$or"].should have(1).elements
  end

end
