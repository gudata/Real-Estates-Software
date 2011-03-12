# == Schema Information
#
# Table name: sells
#
#  id                            :integer(4)      not null, primary key
#  user_id                       :integer(4)
#  client_id                     :integer(4)
#  offer_type_id                 :integer(4)
#  property_type_id              :integer(4)
#  status_id                     :integer(4)
#  address_id                    :integer(4)
#  source_id                     :integer(4)
#  source_value                  :string(255)
#  mongo_document_id             :string(255)
#  property_category_location_id :integer(4)
#  project_id                    :integer(4)
#  project_building              :string(255)
#  project_entrance              :string(255)
#  project_floor                 :integer(4)
#  project_unit                  :string(255)
#  created_at                    :datetime
#  updated_at                    :datetime
#  team_id                       :integer(4)
#  co_owner_id                   :integer(4)
#  valid_to                      :date
#  canceled_until                :date
#  canceled_type_id              :string(255)
#

class Sell < ActiveRecord::Base
  translates :description
  cattr_reader :per_page
  @@per_page = 10;


  before_save :asign_team
  after_save :save_mongo
  before_destroy :destroy_mongo
#  before_save :fix_i18n

  validates :source_id, :user_id, :presence => true

  belongs_to :user
  belongs_to :co_owner, :class_name => "User", :foreign_key => "co_owner_id"
  belongs_to :contact, :foreign_key => 'client_id', :counter_cache => true
  belongs_to :offer_type
  belongs_to :status
  belongs_to :property_category_location
  belongs_to :property_type
  belongs_to :source
  belongs_to :project

  has_many :keywords_sells, 
    :include => {:keyword => [:property_types => :keywords_property_types]},
    :order => "keywords_property_types.position ASC"

  accepts_nested_attributes_for :keywords_sells
  has_many :keywords, :through => :keywords_sells

  has_many :pictures, :as => :imagable
  accepts_nested_attributes_for :pictures, :allow_destroy => true #, :reject_if => proc { |attributes| attributes['picture'].blank? }
  
  has_many :inspections, :as => :inspectable
  accepts_nested_attributes_for :inspections, :allow_destroy => true #, :reject_if => proc { |attributes| attributes['picture'].blank? }

  has_many :documents, :as => :attachable
  accepts_nested_attributes_for :documents, :allow_destroy => true

  has_many :rooms
  accepts_nested_attributes_for :rooms, :allow_destroy => true

  belongs_to :address
  accepts_nested_attributes_for :address, :allow_destroy => true
  #  acts_as_mappable :through => :address

#  scope :sell_offers,  lambda {
#    where(:"offer_types.tag" => Contact::TAG_SELLERS)
#    joins(:offer_types)
#  }
#  scope :rent_offers, lambda {
#    joins(:offer_types)
#    where(:"offer_types.tag" => Contact::TAG_RENTERS)
#  }

  # client_id is still contact_id 
  def contact_id
    client_id
  end

  # make the bridge to mongo
  def canceled_type
    self.canceled_type_id.blank? ? nil : CanceledType.find(self.canceled_type_id)
  end

  def number
    id.to_s
  end

  def keyword tag
    keywords.select { |keyword| keyword.tag == tag }
  end

  def keyword_sell tag
    keywords_sells.select { |ks| ks.keyword.tag == tag }
  end

  # Записваме в keywords_sells
  # Attributes example structure
  # {"6"=>{"value"=>"", "keyword_id"=>"8"}, "11"=>{"value"=>"", "keyword_id"=>"15"}, "22"=>{"value"=>["", "", "", "", "", ""], "keyword_id"=>"28"}, "7"=>{"value"=>"", "keyword_id"=>"9"}, "12"=>{"value"=>"", "keyword_id"=>"16"}, "8"=>{"value"=>"", "keyword_id"=>"10"}, "13"=>{"value"=>"", "keyword_id"=>"17"}, "9"=>{"value"=>"", "keyword_id"=>"13"}, "14"=>{"value"=>"", "keyword_id"=>"18"}, "15"=>{"value"=>"", "keyword_id"=>"19"}, "0"=>{"value"=>"", "keyword_id"=>"1"}, "16"=>{"value"=>"", "keyword_id"=>"20"}, "1"=>{"value"=>"", "keyword_id"=>"2"}, "17"=>{"value"=>"", "keyword_id"=>"21"}, "2"=>{"value"=>"", "keyword_id"=>"5"}, "18"=>{"value"=>"", "keyword_id"=>"22"}, "3"=>{"value"=>"", "keyword_id"=>"11"}, "19"=>{"value"=>"", "keyword_id"=>"24"}, "20"=>{"value"=>"", "keyword_id"=>"25"}, "4"=>{"value"=>"08 Jun 2010", "keyword_id"=>"6"}, "10"=>{"value"=>"", "keyword_id"=>"14"}, "21"=>{"value"=>"", "keyword_id"=>"26"}, "5"=>{"value"=>"", "keyword_id"=>"7"}}
  def keywords_sells_attributes=(attributes)
    attributes.each do |attribute|
      keyword_id = attribute.last[:keyword_id].to_i
      value = attribute.last[:value]
      value = multiple_values_to_string(value) if value.class.name == "Array"
      if self.new_record?
        self.keywords_sells.build(:value => value, :keyword_id => keyword_id)
      else        
        self.keywords_sells.detect(Proc.new {
            self.keywords_sells.build(:keyword_id => keyword_id, :value => value)
          }){|record| record.keyword_id == keyword_id}.update_attributes(:value => value)
      end
    end
  end

  #  Some mongo stuff
  def sell_document
    SellDocument.find(self.mongo_document_id)
  end

  def get_pictures
    picture_styles = Picture.attachment_definitions[:picture][:styles].keys
    self.pictures.collect do |picture|     
      picture_hash = {}
      picture_styles.each do |picture_style|
        picture_hash[picture_style] = {
          :url => picture.url(picture_style),
          :style => picture_style
        }
      end
      picture_hash
    end
  end

  #####################################################################################
  private

  # при ключови думи с повече от една стойност Rails ги санитизира и трябва да
  # се оправят преди да се запишат
  def multiple_values_to_string(value)
    array_to_string_value = ""
    value.each do |char|
      array_to_string_value +=  char + ',' unless char.blank?
    end
    array_to_string_value = array_to_string_value.blank? ? "" : array_to_string_value.chop!
  end

  # TODO - Да се фиксират статусите на офертите при добавяне на оглед сменя стауса на офертат на "Огледана"
  def change_status_on_inspection
    unless self.inspections.blank?
      self.attributes={:status_id => 2}
      self.save
    end
  end

  # Правим запис на атрибутите по които ще се извършва търсенето в Mongo документ
  def save_mongo
    SellDocument.from_active_record self
  end

  def destroy_mongo
    ::Rails.logger.debug("Triggerd before_destroy_mongo for #{self.id}")
    SellDocument.destroy_mongo_record self
  end

  def asign_team
    self.team_id = self.user.team_id
  end

#  def fix_i18n
#    current_description = description
#    I18n.with_locale([:ru, :bg].delete(I18n.locale)) {
#      description = current_description
#    }
#  end
end
