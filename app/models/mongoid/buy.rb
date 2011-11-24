class Buy
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::I18n
  include Mongoid::Versioning
  extend ActiveModel::Translation
  include ActiveModel::Observing
  #include Mongoid::ActiverecordPatch
  #
  #before_validation :fix_id_types
  before_validation :asign_team

  embeds_many :address_documents
  
  embeds_many :attachments
  before_save :touch_last_update
  accepts_nested_attributes_for :attachments #, :allow_destroy => true
  
  embeds_many :search_criterias
  accepts_nested_attributes_for :search_criterias, :allow_destroy => true

  #  before_save :make_contact_client
  #  before_destroy :make_client_contact
  #
  validates_presence_of :contact_id, :offer_type_id, :created_by_user_id, :status_id, :number, :user_id, :source_id

  # belongs_to_related  = referenced_in
  referenced_in :status
  referenced_in :offer_type, :class_name => "OfferType",  :index => true
  referenced_in :contact, :index => true
  referenced_in :user, :index => true
  referenced_in :team, :index => true
  referenced_in :created_by_user, :class_name => "User", :index => true
  referenced_in :source, :index => true
  referenced_in :canceled_type, :index => true
  
  belongs_to_related :co_owner, :class_name => "User"

  field :valid_to, :type => Date
  field :canceled_until, :type => Date
  field :source_value
  field :number, :type => Integer, :index => true
  field :marked_sell_documents, :type => Hash, :default => {}
  field :last_updated, :type => Integer, :default => Time.now.to_i
  localized_field :name
  localized_field :description
  field :reverse_offer_type, :type => Boolean, :default => true
  # пазим id-та на SellDocument => BuyStatus

  # търсене в оферти купува
  def hash_for_searching
    hash = {}
    if reverse_offer_type
      raise "Липсва офертен тип за id: #{self.offer_type_id} и може би неговият противолоположен" if !self.offer_type_id.blank? and self.offer_type.nil?
      hash[:offer_type_id] = self.offer_type.oposite_offer_type_id unless self.offer_type_id.blank?
    else
      hash[:offer_type_id] = self.offer_type_id unless self.offer_type_id.blank?
    end

    #    hash[:status_id] = self.status_id unless self.status_id.blank?


    #db.sell_documents.find({ $or: [{"address_document.district_id": "1", "address_document.street": "Feil Summit"}, {"address_document.street": "Keenan Creek"}]}, {"address_document":1})

    address_criterias = address_documents.collect do |address_document|
      dot_syntax_hash = {}
      address_document.hash_for_searching.each do |key, value|
        dot_syntax_hash["address_document.#{key}"] = value
      end
      dot_syntax_hash.empty? ? nil : dot_syntax_hash
    end.compact

    hash["$or"] = address_criterias unless address_criterias.empty?

    hash
  end

  #  def status
  #    $cache[Status].select{|e| e.id.to_s == status_id}.first
  #  end
  #
  #  def offer_type
  #    $cache[OfferType].select{|e| e.id.to_s == offer_type_id}.first
  #  end

  protected
  def make_contact_client
    self.contact.make_contact_client(self, true)
  end

  def make_client_contact
    self.contact.make_contact_client(self, false) unless self.contact.has_offers_for_user(self.user)
  end

  def asign_team
    self.team_id = self.user.team_id
  end

  def touch_last_update
    self.last_updated = Time.now
  end
end

__END__


Buy.create(:offer_type_id => "2", :user_id => "1", :status_id => "1", :source_id => "1", :contact_id => "94", :number => "1", :created_by_user_id => "94" )
