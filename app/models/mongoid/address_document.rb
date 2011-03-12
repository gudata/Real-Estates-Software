class AddressDocument
  include Mongoid::Document
  include Mongoid::Timestamps
  #  include MongoTranslation
  include Mongoid::I18n
  include Mongoid::ActiverecordPatch
  before_validation :fix_id_types
  
  belongs_to_related :city
  # http://groups.google.com/group/mongoid/browse_thread/thread/f60bac411864651f/9a51d83eb87c893c?lnk=gst&q=Tony#9a51d83eb87c893c

  #  alias_method :orig_city_id, :city_id
  #  def city_id
  #    orig_city_id.blank? ? nil : orig_city_id.to_i
  #  end

  belongs_to_related :country, :index => true
  belongs_to_related :district, :index => true
  belongs_to_related :municipality, :index => true
  belongs_to_related :quarter, :index => true
  belongs_to_related :floor_type
  belongs_to_related :street_type
  
  embedded_in :buy, :inverse_of => :address_documents
  field :street
  field :building
  field :number

  # deprecated - user floor_type_id
  field :floor
  field :apartment
  field :entrance
  localized_field :description

  field :lat, :type => Float
  field :lng, :type => Float

  def empty?
    country_id.blank? and district_id.blank? and
      municipality_id.blank? and city_id.blank? and quarter_id.blank? and
      street.blank? and number.blank? and floor.blank? and apartment.blank? and entrance.blank? and lat.blank? and lng.blank?
  end

  def hash_for_searching
    address_fields = {}
    address_fields[:country_id] = self.country_id unless self.country_id.blank?
    address_fields[:district_id] = self.district_id unless self.district_id.blank?
    address_fields[:municipality_id] = self.municipality_id unless self.municipality_id.blank?
    address_fields[:city_id] = self.city_id unless self.city_id.blank? or self.city_id == 0
    address_fields[:quarter_id] = self.quarter_id unless self.quarter_id.blank? or self.quarter_id == 0
    address_fields.empty? ? {} : address_fields
  end
  
  # I need this method for the cancan ability
  def user
    self.buy.user
  end
  def user_id
    self.buy.user_id
  end

  def init_from(address)
    self.country_id = address.country_id
    self.district_id = address.district_id
    self.municipality_id = address.municipality_id
    self.city_id = address.city_id
    self.quarter_id = address.quarter_id
    self.street = address.street
    self.number = address.number
    self.building = address.building
    self.floor = address.floor
    self.floor_type_id = address.floor_type_id
    self.street_type_id = address.street_type_id
    self.apartment = address.apartment
    self.lat = address.lat
    self.lng = address.lng
    self
  end

end