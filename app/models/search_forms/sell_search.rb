# прокси клас към търсенето (Buy)
# прави оферта buy и търси чрез Buy класа.
require 'will_paginate/array'

class SellSearch
  include SearchHelper
  extend ActiveModel::Naming
  # include ActiveModel::Validations

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

  def initialize params
    ::Rails.logger.debug("Initializing a search")
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
    
  end

  def sell_documents
    buy = get_buy
    
    @matching_sell = MatchingSell.new
    @matching_sell << buy

    # add some additional criterias
    if number.blank?
      @matching_sell.add({:user_id => user_id}, true) unless user_id.blank?

      @matching_sell.add({:co_owner_id => co_owner_id}, true) unless co_owner_id.blank?
      @matching_sell.add({:team_id => team_id}, true) unless team_id.blank?

      @matching_sell.add({"address_document.quarter_id" => { "$in" => quarter_ids} }, true) unless quarter_ids.blank?
    else
      @matching_sell.add({:number => number}, true)
    end

    if number.blank?
      unless status_ids.blank? && status_ids.empty?
        #if status_ids.size != $cache[Status].size optimization some day - take in mind that some statuses could be active
        status_hash = {:status_id => {"$in" => status_ids.collect{|id| id if !id.blank?}.compact}}
        @matching_sell.add(status_hash, true)
      end

      order_array = get_order_hash
      sell_documents = @matching_sell.sell_documents.first
      sell_documents.order_by(order_array) if sell_documents
    else
      sell_documents = ([] << SellDocument.from_active_record(Sell.find(number)))
    end

    sell_documents
  end

  private

  def get_buy
    # Търсенето се прави като се минава през оферта купува.
    buy = Buy.new()
    buy.reverse_offer_type = false
    
    buy.number = number.to_i unless number.blank?
    
    if number.blank?
      buy.offer_type_id = offer_type_id unless offer_type_id.blank?
      buy.user_id = user_id unless user_id.blank?

      search_criteria = SearchCriteria.new()
    
      search_criteria.property_type_id = property_type_id unless property_type_id.blank?
      search_criteria.terms << fill_range(Term.new(:tag => "price"), price_from, price_to)
      search_criteria.terms << fill_range(Term.new(:tag => "area"), area_from, area_to)
      search_criteria.terms << fill_range(Term.new(:tag => "rooms"), rooms_from, rooms_to)

      if !apartment_type_ids.blank? and !apartment_type_ids.empty? 
        search_criteria.terms << Term.new(
          :tag => "apartment_type",
          :values => apartment_type_ids.collect{|id| id if !id.blank?}.compact
        )
      end

      if !construction_type_ids.blank? and !construction_type_ids.empty?  
        search_criteria.terms << Term.new(
          :tag => "construction",
          :values => construction_type_ids.collect{|id| id if !id.blank?}.compact
        )
      end
    
      #    raise search_criteria.hash_for_searching.inspect
    
      buy.search_criterias << search_criteria

      @address_documents.each do |address_document|
        buy.address_documents << address_document
      end
    end
    

    buy
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