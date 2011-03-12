# == Schema Information
#
# Table name: projects
#
#  id                            :integer(4)      not null, primary key
#  name                          :string(255)
#  contact_id                    :integer(4)
#  status_id                     :integer(4)
#  source_id                     :integer(4)
#  reference_point               :string(255)
#  property_category_location_id :integer(4)
#  user_id                       :integer(4)
#  team_id                       :integer(4)
#  contact_person                :string(255)
#  contact_person_phone          :string(255)
#  address_id                    :integer(4)
#  furnish_id                    :integer(4)
#  website                       :string(255)
#  start_date                    :date
#  finish_date                   :date
#  managment_fee                 :float
#  discount                      :float
#  brokerage                     :float
#  description                   :text
#  additional_description        :text
#  active                        :boolean(1)
#  project_stage_id              :integer(4)
#  created_at                    :datetime
#  updated_at                    :datetime
#  source_value                  :string(255)
#

class Project < ActiveRecord::Base
  @@per_page = 10
  
  translates :name, :description, :aditional_description, :reference_point
  belongs_to :status
  belongs_to :source
  belongs_to :furnish
  belongs_to :user
  belongs_to :contact, :counter_cache => true
  belongs_to :team
  belongs_to :property_category_location
  belongs_to :project_stage

  before_save :asign_team
    
  DEFAULT_INCLUDES = {
    :status => :translations,
    :translations => [],
    :user => [],
    :contact => [
      :phones => {:phone_type => :translations},
      :internet_comunicators => {:internet_comunicator_type => :translations}
    ],
    :pictures => :translations
  }

  default_scope :include => DEFAULT_INCLUDES
  #    :conditions => {"statuses.hide_on_this_status" => false}

  scope :active, lambda {|active|
    if active=="active"
      where("statuses.hide_on_this_status" => false)
    else
      where("statuses.hide_on_this_status" => true)
    end
  }

  scope :ascend_by_location, order("property_category_location.id ASC")
  scope :descend_by_localtion, order("property_category_location.id DESC")

  belongs_to :address
  accepts_nested_attributes_for :address, :allow_destroy => true

  #  acts_as_polymorphic_paperclip

  has_many :pictures, :as => :imagable
  accepts_nested_attributes_for :pictures, :allow_destroy => true #, :reject_if => proc { |attributes| attributes['picture'].blank? }

  has_many :inspections, :as => :inspectable
  accepts_nested_attributes_for :inspections, :allow_destroy => true #, :reject_if => proc { |attributes| attributes['picture'].blank? }

  has_many :documents, :as => :attachable
  #  cattr_accessor(:injected_error)
  accepts_nested_attributes_for :documents, :allow_destroy => true

  has_many :sells
  accepts_nested_attributes_for :sells, :allow_destroy => true

  #    is_blank = attributes['document'].blank?
  #    if is_blank
  #      @@injected_error = "error"
  #    end
  #    is_blank
  #  }

  validate :name, :presence => true
  validate :status, :presence => true
  validate :source, :presence => true
  validate :user, :presence => true
  validate :contact_person,:presence => true
  validate :contact_person_phone, :presence => true
  validate :finish_date, :presence => true
  validate :property_category_location, :presence => true
  validate :project_stage, :presence => true

  #  validates_presence_of :address

  scope :full_name, lambda { |string|
    where('last_name like :string OR first_name like :string OR second_name like :string', {:string => "%#{string}%"})
    includes(DEFAULT_INCLUDES)
    joins(:user)
  }

  has_one :country, :through => :address
  #  has_one :district, :through => :address
  #  has_one :municipality, :through => :address
  #  has_one :city, :through => :address
  #  has_one :quarter, :through => :address

  default_scope :include => :translations



  def make_sell attributes = {}
    area = Keyword.find_by_tag("area")
    price = Keyword.find_by_tag("price")

    raise "Системата трябва да има ключова дума с таг area" unless area
    raise "Системата трябва да има ключова дума с таг price" unless price

    if attributes.key? :keywords_sells_attributes
      # Използваме тези които са дошли от контролера
    else
      price_keyword_sell = KeywordsSell.new(:keyword => price, :value => nil)
      area_keyword_sell = KeywordsSell.new(:keyword => area, :value => nil)

      attributes[:keywords_sells] = [area_keyword_sell, price_keyword_sell]
    end

    
    default_attributes = {
      :user_id => self.user_id,
      :client_id => self.contact_id,
      :status_id => self.status_id,
      :source_id => self.source_id,
      :source_value => self.source_value,
      :property_category_location_id => self.property_category_location_id,
      :project_id => self.id
    }
    

    sell = self.sells.build(default_attributes.merge(attributes))

    if attributes.key? :address_attributes
      Rails.logger.debug("We use those from the controller #{attributes[:address_attributes].inspect}")
    else
      Rails.logger.debug("We build a new one from the project #{self.address.attributes.inspect}")
      sell.build_address(self.address.attributes)
    end

    sell.user_id = attributes[:user_id] if attributes.key? :user_id
    
    sell
  end

  private
  def asign_team
    self.team_id = self.user.team_id
  end
end
