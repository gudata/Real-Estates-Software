module SellHelperMethods
  def keywords
    keywords = [
      Keyword.make(:furniture),
      Keyword.make(:infrastructure),
      Keyword.make(:phone),
      Keyword.make(:area),
      Keyword.make(:price),
    ]
    
    buy_values =  {
      "furniture" => {
        :values => ["1", "2"] 
      },
      "phone" => {
        :value => 1
      },
      "infrastructure" => {
        :values => ["1", "3"]
      },
      "area" => {
        :from => 90,
        :to => 130,
      },
      "price" => {
        :from => 50000,
        :to => 150000,
      }
    }
    sell_values =  {
      "furniture" => "2", # изброимите типове са стрингове защото ги сплитваме
      "infrastructure" => "1,2,3",
      "phone" => 1,
      "area" => 120,
      "price" => 75000,
    }
    [
      keywords, buy_values, sell_values
    ]
  end

  # връща противоположни офертни типове
  def get_buy_sell_offer_types
    buy_offer_type = OfferType.make(
      :category => OfferType::BUY_TYPE
    )
    sell_offer_type = OfferType.make(
      :category => OfferType::SELL_TYPE,
      :oposite_offer_type => buy_offer_type
    )
    buy_offer_type.oposite_offer_type = sell_offer_type
    buy_offer_type.save
    [buy_offer_type, sell_offer_type]
  end
  
  def sell_with_keywords(user, contact, property_type, status, sell_offer_type, keywords, keyword_values, address)
    property_type.keywords = keywords

    sell = Sell.make(
      :user => user,
      :contact => contact,
      :address => address,
      :property_type => property_type,
      :offer_type => sell_offer_type,
      :status => status,
      :source => Source.make,
      :source_value => Sham.name
      # TODO: Наложи се да ги задам по-долу к. думите
      #      :keywords => property_type.keywords << това трябва да се направи през keyword_sells
    )
    sell.keywords = property_type.keywords

    sell.keywords_sells = []
    sell.keywords.each_with_index do |keyword, index|
      sell.keywords_sells << KeywordsSell.create(
        :sell_id => sell,
        :keyword_id => keyword.id,
        :value => keyword_values[keyword.tag]
      )
    end
    sell.save
    sell
  end

  def make_search_criteria(options)
    search_criteria = SearchCriteria.new
    search_criteria.property_type_id = options[:property_type].id
    search_criteria.set_new_terms(options[:keywords])
    search_criteria.terms = set_values_on_terms search_criteria.terms, options[:keywords_buy_values]
    
    search_criteria
  end

  def set_values_on_terms terms, keyword_values
    terms.collect do |term|
      keyword_values.should have_key term.tag
      keyword_values[term.tag].each do |key, value|
        term.send("#{key}=", value)
      end
      term
    end
  end
  
end