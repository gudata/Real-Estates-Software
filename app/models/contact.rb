# == Schema Information
#
# Table name: contacts
#
#  id                   :integer(4)      not null, primary key
#  is_company           :boolean(1)
#  added_by             :integer(4)
#  address_id           :integer(4)
#  nationality_id       :integer(4)
#  important            :boolean(1)
#  web                  :string(255)
#  person_first_name    :string(255)
#  person_last_name     :string(255)
#  person_middle_name   :string(255)
#  person_employment    :string(255)
#  person_position      :string(255)
#  company_name         :string(255)
#  company_branch       :string(255)
#  bank_account         :string(255)
#  iban                 :string(255)
#  mol_first_name       :string(255)
#  mol_last_name        :string(255)
#  mol_phone            :string(255)
#  picture_file_name    :string(255)
#  picture_content_type :string(255)
#  picture_file_size    :integer(4)
#  projects_count       :integer(4)      default(0)
#  sells_count          :integer(4)      default(0)
#  key                  :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

class Contact < ActiveRecord::Base

  TAG_ALL     = "clients"
  TAG_SELLERS = "sellers"
  TAG_LETTERS = "letters"
  TAG_BUYERS = "buyers"
  TAG_RENTERS = "renters"


  def self.client_types
    [
      [I18n.t("Всички клиенти", :scope => [:layouts, :admin]), TAG_ALL],
      [I18n.t("Продавачи", :scope => [:layouts, :admin]), TAG_SELLERS],
      [I18n.t("Наемодатели", :scope => [:layouts, :admin]), TAG_LETTERS],
      [I18n.t("Наематели", :scope => [:layouts, :admin]), TAG_RENTERS],
      [I18n.t("Купувачи", :scope => [:layouts, :admin]), TAG_BUYERS]
    ]
  end
  # TODO - да се направят named_scope-ове за Mongo Buy офертите
  require 'md5'
  before_create :add_key

  cattr_reader :per_page
  @@per_page = 9
  translates :description

  validates :key, :on => :update, :presence => true
  #  validates_uniqueness_of :key

  belongs_to :address, :dependent => :destroy
  accepts_nested_attributes_for :address, :allow_destroy => :true

  has_many :contacts_users
  has_many :users, :through => :contacts_users

  has_many :contacts_contact_categories, :dependent => :destroy
  has_many :contact_categories, :through => :contacts_contact_categories

  has_many :contacts_spheres, :dependent => :destroy
  has_many :spheres, :through => :contacts_spheres

  has_many :phones, :dependent => :destroy
  accepts_nested_attributes_for :phones, :allow_destroy => true

  has_many :projects, :dependent => :destroy
  accepts_nested_attributes_for :projects, :allow_destroy => true

  has_many :internet_comunicators, :dependent => :destroy
  accepts_nested_attributes_for :internet_comunicators, :allow_destroy => true

  scope :internet_comunicators_for_search, lambda { |string|
    where( 'value like :string', {:string => "%#{string}%"})  unless string.blank?
  }


  belongs_to :nationality, :class_name => "Country", :foreign_key => :nationality_id

  has_many :sells, :class_name => 'Sell', :foreign_key => 'client_id', :dependent => :destroy

  scope :clients_type, lambda {|type|

    case type
    when TAG_ALL
      where ["contacts_users.is_client = ?", true]
    when TAG_SELLERS
      where ["contacts_users.sell_count > 0"]
    when TAG_LETTERS
      where ["contacts_users.letters_count > 0"]
    when TAG_BUYERS
      where ["contacts_users.buy_count > 0"]
    when TAG_RENTERS
      where ["contacts_users.rent_count > 0"]
    end
    #      where(["contacts_users.is_client = ? AND offer_types.tag = ?", true, type])
  }
  
  scope :ascend_by_name,
    :order => "person_first_name ASC, person_last_name ASC, company_name ASC"

  scope :named_like, lambda {|name|
    where(
      ["person_first_name like :name OR person_last_name like :name OR person_middle_name like :name OR company_name like :name",
        {:name => "%#{name}%"}]
    )
  }

  search_methods :named_like, :clients_type

  scope :descend_by_name,
    :order => "person_first_name DESC, person_last_name DESC, company_name DESC"

  scope :ascend_by_user_real_name,
    :order => "users.id ASC"

  scope :descend_by_user_real_name,
    :order => "users.id DESC"

  def buys
    Buy.where("contact_id" => self.id)
  end

  def sell_documents
    SellDocument.where("contact_id" => self.id)
  end

  has_attached_file :picture,
    :storage => :filesystem,
    :default_style => :thumb,
    :styles => {
    :thumb => "80>x53",
    :small_thumb => "50>x50",
    :small => "468>x60",
    :normal  => "768>x96",
  }

  
  def display_name(type = :full)
    case type
    when :full
      [self.person_first_name, self.person_middle_name, self.person_last_name].join(" ")
    when :short
      return [self.person_first_name,self.person_last_name].join(" ")
    when :initial
      [self.person_first_name.first, self.person_middle_name.first, self.person_last_name.first].compact.join(" ")
    when :company
      self.company_name
    end
  end

  def name
    self.is_company == true ? self.display_name(:company) : self.display_name(:full)
  end

  def validate

    if self.phones.blank? and self.internet_comunicators.blank?
      #      errors.add_to_base(:less_one_phone_required)
      errors.add(:base, :less_one_phone_required)
    end

    if is_company == true
      errors.add_on_blank(:company_name, :empty)
      self.is_company = true
    else
      errors.add_on_blank(:person_first_name, :empty)      
      self.is_company = false
    end
    
  end

  def makeit_client_for_user(user)
    contact_user =  self.contacts_users.find_by_user_id(user)
    unless contact_user.blank?
      contact_user.update_attribute(:is_client, true)
    end
  end

  def is_client?
    self.contacts_users.each.detect(Proc.new{false}){|record| record.is_client == true}
  end

  def is_client_for_user?(user)
    contact_user =  self.contacts_users.find_by_user_id(user)
    # внимание, може да сме шев на този потребител
    contact_user.nil? ? false : contact_user.is_client
  end


  def has_offers_for_user(user)
    
    ! ( user.sells.find_by_client_id(self).blank? and
        Buy.where({:contact_id => self.id, :user_id => user.id}).count == 0 and
        user.projects.find_by_contact_id(self).blank?
    )
  end

  # calc for each user
  # calc for the global user
  def calc_offers(record)

    # sells_count - не се използва!!!!
    
    record_user = record.user
    contact = record.contact
    contact_user = self.contacts_users.find_by_user_id(record_user.id)
    
    case record
    when Buy
      (buy_count, buy_count_for_contact, buy_count_active, buy_count_for_contact_active) =
        count_buyers(record, OfferType.for(:buyers).id)
      (rent_count, rent_count_for_contact, rent_count_active, rent_count_for_contact_active) =
        count_buyers(record, OfferType.for(:renters).id)
      
      ContactsUser.update_all({
          :buy_count => buy_count,
          :buy_count_active => buy_count_active,
          :rent_count => rent_count,
          :rent_count_active => rent_count_active,
        }, {:id => contact_user.id})

      Contact.update_all({
          :buy_count => buy_count_for_contact,
          :buy_count_active => buy_count_for_contact_active,
          :rent_count => rent_count_for_contact,
          :rent_count_active => rent_count_for_contact_active,
        }, {:id => contact.id})

    when Sell
      (sell_count, sell_count_for_contact, sell_count_active, sell_count_for_contact_active) =
        count_sellers(record, OfferType.for(:sellers).id)
      (letters_count, letters_count_for_contact, letters_count_active, letters_count_for_contact_active) =
        count_sellers(record, OfferType.for(:letters).id)

      ContactsUser.update_all({
          :sell_count => sell_count,
          :sell_count_active => sell_count_active,
          :letters_count => letters_count,
          :letters_count_active => letters_count_active,
        }, {:id => contact_user.id})

      Contact.update_all({
          :sell_count => sell_count_for_contact,
          :sell_count_active => sell_count_for_contact_active,
          :letters_count => letters_count_for_contact,
          :letters_count_active => letters_count_for_contact_active,
        }, {:id => contact.id})
    when Project

    end

  end

  # Използва се в обзървъра за оферти, когато ги трием
  def make_contact_client(record, flag)
    raise("Контакта трябва да има потребител преди да бъде записан") if record.user.blank?
    record_user = record.user

    contact_user = self.contacts_users.find_by_user_id(record_user.id)
    if contact_user.blank?
      contact_user = ContactsUser.create(:user_id => record_user.id,
        :contact_id => self.id,
        :is_client => true  # if we have record it IS a client
      )
    end
    logger.debug "  правя user_id:#{record_user.id} клиент: #{flag}"
    contact_user.update_attribute(:is_client, flag)
  end

  def make_contact_client_for_user user, flag
    contact_user =  self.contacts_users.find_by_user_id(user)
    unless contact_user.blank?
      contact_user.update_attribute(:is_client, flag)
    end
  end
  
  def add_to_users user, client_flag = false
    ap "adding #{user.id} as #{client_flag} to self users. valid = > #{user.valid?}"
    self.users << user
    self.make_contact_client_for_user(user, client_flag)
  end

  def self.reset_counter_cache
    Contact.find_each do |object|
      object.class.update_all("sells_count =  #{Sell.where(:client_id => object.id).count()}", "id=#{object.id}")
    end
  end

  def self.reset_client_flag
    ContactsUser.update_all("is_client = false")
    Sell.find_each do |sell|
      sell.contact.make_contact_client(sell, true)
    end.reject{|e| true}


    Buy.all.each do |buy|
      buy.contact.make_contact_client(buy, true)
    end.reject{|e| true}

  end

  def is_company?
    is_company
  end
  
  private

  def add_key
    self.key = MD5.md5(rand(99131551412).to_s).to_s
  end

  def count_buyers record, offer_type_id
    buy_count = Buy.where(
      :user_id => record.user_id,
      :contact_id => record.contact_id,
      :offer_type_id => offer_type_id
    ).count()

    buy_count_for_contact = Buy.where(
      :contact_id => record.contact_id,
      :offer_type_id => offer_type_id
    ).count()

    # do the same but only for the active offers
    buy_count_active = Buy.where(
      :user_id => record.user_id,
      :contact_id => record.contact_id,
      :offer_type_id => offer_type_id,
      :status_id.in => Status.active.collect{|status| status.id}
    ).count()

    buy_count_for_contact_active = Buy.where(
      :contact_id => record.contact_id,
      :offer_type_id => offer_type_id,
      :status_id.in => Status.active.collect{|status| status.id}
    ).count()
    
    [buy_count, buy_count_for_contact, buy_count_active, buy_count_for_contact_active]
  end

  def count_sellers record, offer_type_id
    sell_count = SellDocument.where(
      :user_id => record.user_id,
      :contact_id => record.contact_id,
      :offer_type_id => offer_type_id
    ).count()

    sell_count_for_contact = SellDocument.where(
      :contact_id => record.contact_id,
      :offer_type_id => offer_type_id
    ).count()

    # do the same but only for the active offers
    sell_count_active = SellDocument.where(
      :user_id => record.user_id,
      :contact_id => record.contact_id,
      :offer_type_id => offer_type_id,
      :status_id.in => Status.active.collect{|status| status.id}
    ).count()

    sell_count_for_contact_active = SellDocument.where(
      :contact_id => record.contact_id,
      :offer_type_id => offer_type_id,
      :status_id.in => Status.active.collect{|status| status.id}
    ).count()

    [sell_count, sell_count_for_contact, sell_count_active, sell_count_for_contact_active]
  end

end
