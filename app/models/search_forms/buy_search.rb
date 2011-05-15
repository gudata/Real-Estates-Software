# BuySearch - търсене в оферти купува/наема
# Търси директно в Buy документите

class BuySearch
  include SearchHelper
  extend ActiveModel::Naming
    
  @@search_attributes = [
    :number, 
    :status_ids,
    :offer_type_id,
    :property_type_id,
    :apartment_type_ids,
    :price_from, :price_to, 
    :area_from, :area_to,
    :rooms_to, :rooms_from,
    :team_id,
    :user_id,
    :co_owner_id,
    :city_name,
    :city_id,
    :quarter_ids,
    :exact_price_interval,
    :construction_type_ids
  ]


  SORT_KEYS = {
    :asc => "1",
    :desc => "2",
  }
  SORT_KEYS_INVERT = SORT_KEYS.invert
  
  SORT_KEYS_MAPPING = {
    :created_at => :created_at,
    :city => :city_id,
    :price => :price,
  }
  
  cattr_accessor :search_attributes
  attr_accessor *search_attributes
  attr_accessor :address_documents
  attr_accessor :order_fields
  attr_accessor :only_fields # which fields to be retrieved

  def initialize params
    params_to_i(@@search_attributes, params)

    @address_documents = []
    if params[:address_documents]
      params[:address_documents].collect do |address|
        address_document = AddressDocument.new
        address_document.municipality_id = address[:municipality_id].to_i unless address[:municipality_id].blank?
        #        address_document.city_id = address[:city_id] unless address[:city_id].blank?
        address_document.city_id = @city_id unless params[:city_id].blank?
        #        if !city_name.blank? and !city_name.strip.blank?
        #          city = City.find(:first, :conditions => {:"city_translations.name" => city_name})
        #          if city
        #            address_document.city_id = city.id #address[:city_id]
        #          end
        #        end
        @address_documents << address_document
      end.compact
    else
      @address_documents  << AddressDocument.new()
    end
    
    @order_fields = OpenStruct.new()
    (params[:order_fields] || {}).each do |key, value|
      @order_fields.send("#{key}=", value);
    end
    
    @only_fields = params[:only_fields] ? params[:only_fields] : nil
    
  end

  def buy_documents
    # Търсим директно в документите Buy
    search_hash = get_search_hash
        
    order_array = get_order_hash
    
    Buy.where(search_hash).only(@only_fields).order_by(order_array)
  end

  def get_search_hash
    search_hash = {}
    search_hash[:offer_type_id] = offer_type_id unless offer_type_id.blank?
    search_hash[:number] = number.to_i unless number.blank?
    search_hash[:user_id] = user_id unless user_id.blank?
    search_hash[:co_owner_id] = co_owner_id unless co_owner_id.blank?


    terms = []
    terms << fill_range(Term.new(:tag => "area"), area_from, area_to).hash_for_searching_ranged
    terms << Term.new(:tag => "apartment_type", :values => apartment_type_ids).hash_for_searching unless apartment_type_ids.blank?
    unless construction_type_ids.blank?
      terms << Term.new(:tag => "construction", :values => construction_type_ids.reject{|e| e.blank?}).hash_for_searching 
    end

    price_term = fill_range(Term.new(:tag => "price"), price_from, price_to)
    if price_term.can_do_full_interval? and exact_price_interval == "0"
      Rails.logger.debug "Търсене на цена с гъвкави параметри"
      terms << price_term.hash_for_searching_ranged_loose_ends
    else
      Rails.logger.debug "Търсене на цена с точни граници"
      terms << price_term.hash_for_searching_ranged
    end

    
    terms.compact!

    search_hash[:search_criterias] = {
      "$elemMatch" => {
        :terms => {"$all" => terms},
      }
    } unless terms.empty?
    search_hash[:search_criterias]["$elemMatch"][:property_type_id] = property_type_id unless property_type_id.blank?

    address_hash = @address_documents.collect do |address_document|
      {"$elemMatch" => address_document.hash_for_searching} unless address_document.hash_for_searching.empty?
    end.compact

    # limited to only one address due lack of other requirements
    search_hash[:address_documents] = address_hash.first unless address_hash.empty?
    search_hash["address_documents.quarter_id"] =  {"$in" => quarter_ids} unless quarter_ids.blank?

    search_hash[:user_id] = user_id unless user_id.blank?
    search_hash[:team_id] = team_id unless team_id.blank?
    if !status_ids.blank? and !status_ids.empty? and number.blank?
      #      if status_ids.size != $cache[Status].size optimization some day - take in mind that some statuses could be active
      search_hash[:status_id] = {"$in" => status_ids.collect{|id| id if !id.blank?}.compact}
    end
    search_hash
  end
  
  def get_order_hash
    @order_fields.marshal_dump.collect do |field, value|
      value.blank? ? nil : [SORT_KEYS_MAPPING[field.to_sym], SORT_KEYS_INVERT[value]]
    end.compact
  end
  
  def self.sort_fields_html_names
    SORT_KEYS_MAPPING.keys
  end

  private
  
  # just fills the term
  #
  # if later has_for_searching will return nil or hash
  def fill_range(term, from, to)
    term.to = to unless to.blank?
    term.from = from unless from.blank?
    term
  end
end


__END__
#          { $elemMatch: { tag: "property_type_id", value: 3 } }
db.buys.find({
    "search_criterias.terms": {
      $all: [
        { $elemMatch: { tag: "price", to: { $lte: 95000 } } },
        { $elemMatch: { tag: "apartment_type", values: { $in: [ 4 ] } } },
      ]
    }
  })

db.buys.find({
    search_criterias: {
      $elemMatch:{
        property_type_id: 1,
        terms: {
          $all: [
            { $elemMatch: { tag: "price", to: { $lte: 95000 } } },
            { $elemMatch: { tag: "apartment_type", values: { $in: [ 4 ] } } },
          ]
        }
      }
    }
  })

db.buys.find({
    search_criterias: {
      $in: {
        terms: {
          $all: [
            { $elemMatch: { tag: "price", to: { $lte: 95000 } } },
            { $elemMatch: { tag: "apartment_type", values: { $in: [ 4 ] } } },
          ]
        }
      }
    }
  })


db.buys.find({
    search_criterias: {
      terms: {
        $all: [
          { $elemMatch: { tag: "price", to: { $lte: 95000 } } },
          { $elemMatch: { tag: "apartment_type", values: { $in: [ 4 ] } } },
        ]
      }
    }
  })


Buy.all.each do |buy|
  buy.search_criterias.each do |search_criteria|
    term = search_criteria.term('construction')
    if term and term.values and term.values.size > 1
      ap buy.id
      ap search_criteria.term('construction').inspect
    end
  end
end