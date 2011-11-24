class SellDocument
  
  include Mongoid::Document
  include Mongoid::Timestamps
  #  include MongoTranslation
  include Mongoid::I18n
  include Mongoid::ActiverecordPatch

  before_validation :fix_id_types
  before_save :touch_last_update
#  before_save :fix_i18n

  belongs_to_related :sell
  belongs_to_related :project
  belongs_to_related :user, :index => true

  belongs_to_related :offer_type, :index => true
  belongs_to_related :property_type, :index => true
  belongs_to_related :status, :index => true
  belongs_to_related :source, :index => true
  belongs_to_related :property_category_location
  belongs_to_related :contact

  belongs_to_related :co_owner, :class_name => "User"
  referenced_in :canceled_type, :index => true

  belongs_to_related :address


  belongs_to_related :team, :index => true

  embeds_many :terms
  embeds_one :address_document #< it was address_documents


  field :valid_to, :type => Date
  field :canceled_until, :type => Date

  field :active_record_id, :type => Integer
  field :street
  field :source_value
  field :contact_key
  field :last_updated, :type => Integer, :default => Time.now.to_i
  field :pictures, :type => Array
  localized_field :description
  field :number, :type => Integer, :index => true

  # cached fields for easy access and sorting
  before_save :cache_fields
  field :price, :type => Integer, :index => true
  field :city_id, :index => true

  # translates :description

  def self.destroy_mongo_record active_record_sell
    ::Rails.logger.debug("destroying mongo document #{active_record_sell.mongo_document_id}")
    SellDocument.destroy_all(:conditions => {:id =>  BSON::ObjectId(active_record_sell.mongo_document_id)})
    return true
  end

  
  def self.from_active_record active_record_sell
    # update/create follows
    attributes = self.attributes_for_sell_document active_record_sell

    sell_document = SellDocument.find(:first, :conditions => {
        :sell_id => active_record_sell.id
      }
    )
    
    if sell_document.blank?
      sell_document = SellDocument.new(attributes)

      sell_document.terms = self.get_terms(active_record_sell)
      sell_document.save

      # да кажем и на mysql-а за нас
      #   Nice!
      ActiveRecord::Base.connection.execute "
      UPDATE
      sells
      SET
      mongo_document_id = '#{sell_document.id}'
      WHERE id = #{active_record_sell.id};"

      #      active_record_sell.save(false)
      #      При reload се прецакват асоцииираните keywords
      #      active_record_sell.reload
    else
      # TODO: mongoid patch
      sell_document.terms.delete_all
      sell_document.terms = []

      #      terms_attributes = self.get_terms(active_record_sell) || []
      #      terms_attributes.each do |term_attributes|
      #        sell_document.terms.build(term_attributes)
      #      end
      #      sell_document.terms = self.get_terms(active_record_sell)


      #      sell_document.address_document = AddressDocument.new(attributes[:address_document])
      
      sell_document.address_document.update_attributes(attributes[:address_document])
      
      sell_document.update_attributes(attributes)
      
      sell_document.terms = self.get_terms(active_record_sell)
      sell_document.save
    end
     
    sell_document
  end

  def term tag
    terms.where(:tag => tag).first
  end


  def self.get_terms(active_record)
    active_record.keywords_sells.collect do |keyword_sell|
      t = {
        :keyword_id => keyword_sell.keyword_id,
        :tag => keyword_sell.keyword.tag,
        :name => keyword_sell.keyword.name,
        :patern => keyword_sell.keyword.patern,
        :as => keyword_sell.keyword.as,
        #        :position => sell_keyword.position,
        #        :end_of_line => sell_keyword.end_of_line,
        #        :style => sell_keyword.style,
      }
      case keyword_sell.keyword.kind_of_search
      when "multiple"
        values = keyword_sell.value.nil? ? nil : keyword_sell.value.split(",").map!{|value| value.to_i}
        t.merge!({:values => values})
      else
        t.merge!({:value => keyword_sell.value})
      end

      Term.new(t)
    end
  end

  def term tag
    terms.where(:tag => tag).first
  end
  

  private

  def touch_last_update
    self.last_updated = Time.now
  end
  
  def cache_fields
    self.city_id = address_document.city_id unless address_document.blank?
    self.price = term(:price).value if terms and term(:price)
  end

  def self.attributes_for_sell_document active_record_sell
    attributes = {
      :active_record_id => active_record_sell.id,
      :user_id => active_record_sell.user_id,
      :contact_id => active_record_sell.client_id,
      :contact_key => active_record_sell.contact.key,
      :sell_id => active_record_sell.id,
      :offer_type_id => active_record_sell.offer_type_id,
      :property_type_id => active_record_sell.property_type_id,
      :status_id => active_record_sell.status_id,
      :source_id => active_record_sell.source_id,
      :source_value => active_record_sell.source_value,
      :property_category_location_id => active_record_sell.property_category_location_id,
      :address_id => active_record_sell.address.id,
      :number => active_record_sell.number,
      :address_document => {
        :country_id => active_record_sell.address.country_id,
        :city_id => active_record_sell.address.city_id,
        :district_id => active_record_sell.address.district_id,
        :municipality_id => active_record_sell.address.municipality_id,
        :quarter_id => active_record_sell.address.quarter_id,
        :street => active_record_sell.address.street,
        :lat => active_record_sell.address.lat,
        :lng => active_record_sell.address.lng,
      },
      :description => active_record_sell.description,
      :team_id => active_record_sell.user.team_id,
      :project_id => active_record_sell.project_id,
      :pictures => active_record_sell.get_pictures,
      :co_owner_id => active_record_sell.co_owner_id,
      
      :canceled_type => active_record_sell.canceled_type,
      :valid_to => active_record_sell.valid_to,
      :canceled_until => active_record_sell.canceled_until,
      #      :permit_building_at => active_record_sell.permit_building_at,
      #      :permit_using_at => active_record_sell.permit_using_at,


      # we need the following fields for speed purposes to list an property
      
    }
    attributes
  end

#  def fix_i18n
#    Rails.logger.debug("fix_i18n")
#    current_description = description
#    other_locale = [:ru, :bg].delete(I18n.locale)
#    I18n.with_locale(other_locale) {
#      Rails.logger.debug("for locale #{other_locale} saving description = '#{current_description}'")
#      self.description = current_description if current_description.blank?
#    }
#  end

end
