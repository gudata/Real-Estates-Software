# == Schema Information
#
# Table name: users
#
#  id                   :integer(4)      not null, primary key
#  login                :string(255)     not null
#  email                :string(255)     not null
#  crypted_password     :string(255)     not null
#  password_salt        :string(255)     not null
#  persistence_token    :string(255)     not null
#  single_access_token  :string(255)     not null
#  perishable_token     :string(255)     not null
#  login_count          :integer(4)      default(0), not null
#  failed_login_count   :integer(4)      default(0), not null
#  last_request_at      :datetime
#  current_login_at     :datetime
#  last_login_at        :datetime
#  current_login_ip     :string(255)
#  last_login_ip        :string(255)
#  active               :boolean(1)      default(TRUE), not null
#  signature            :text
#  chat                 :text
#  webpage              :string(255)
#  first_name           :string(255)
#  last_name            :string(255)
#  second_name          :string(255)
#  assistant            :boolean(1)
#  company_webpage      :string(255)
#  phone                :string(255)
#  mobile               :string(255)
#  birth                :datetime
#  locale               :string(255)
#  picture_file_name    :string(255)
#  picture_content_type :string(255)
#  picture_file_size    :integer(4)
#  role_id              :integer(4)
#  parent_id            :integer(4)
#  lft                  :integer(4)
#  rgt                  :integer(4)
#  real_name            :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  user_id              :integer(4)
#  office_id            :integer(4)
#  team_id              :integer(4)
#


class User < ActiveRecord::Base
  scope :phones_matches, lambda {|str|
    where(["mobile LIKE :phone OR phone LIKE :phone", {:phone => "%#{str}%"}])
  }
  scope :name_matches, lambda {|str|
    where(["first_name LIKE :name OR second_name LIKE :name OR last_name LIKE :name", {:name => "%#{str}%"}])
  }
  scope :phone_matches, lambda {}
  search_methods :name_matches
  
  # TODO - трябва да се напише метод който да връща
  # наследниците без партньор и гост
  before_save :set_name
  before_update :set_name

  belongs_to :role
  belongs_to :office
  belongs_to :team

  #  @@all_fields_required_by_default = false

  #  default_scope :include => [:role]
  
  has_one :person, :as => :referential
  accepts_nested_attributes_for :person, :allow_destroy => true
  #  validates_presence_of  :login, :email, :mobile, :phone, :first_name, :last_name

  #  validates_associated :person

  has_many :contacts_users
  has_many :contacts, :through => :contacts_users
  has_many :sells
  has_many :projects
    
  cattr_reader :per_page
  @@per_page = ::Rails.env == "development" ? 10 : 20


  @@user_ownerships_cache = {}

  acts_as_nested_set
  #  belongs_to :parent, :class_name => "User", :foreign_key => "user_id"
  
  # http://rdoc.info/projects/binarylogic/authlogic
  # http://github.com/binarylogic/authlogic_example/tree/master
  # "OpenID tutorial", "http://www.binarylogic.com/2008/11/21/tutorial-using-openid-with-authlogic"
  acts_as_authentic do |c|
    #    c.my_config_option = my_value # for available options see documentation in: Authlogic::ActsAsAuthentic
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
  
  #  validates_attachment_presence :picture
  #  validates_attachment_size :picture, :less_than => 20.megabytes, :more_than => 90
  #  validates_attachment_content_type :picture,
  #    :content_type => ['image/jpeg','image/pjpeg', 'image/x-png', 'image/gif', 'image/png'],
  #    :message => "Sorry, I understand only jpg, png or gif image files."

  def display_name(type = :full)
    names = []
    case type
    when :full
      "#{first_name} #{second_name } #{last_name}"
    when :short
      names << first_name unless first_name.blank?
      names << "#{second_name.first}." unless second_name.blank?
      names << last_name unless last_name.blank?
      names.join(" ")
    when :initial
      "#{first_name.first}. #{second_name.first}. #{last_name.first}."
    end
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end

  def self.find_by_username_or_email(login)
    find_by_smart_case_login_field(login) || find_by_email(login)
  end

  def role? role_array_or_sym
    case role_array_or_sym
    when Symbol
      return Role.get_ident(role_array_or_sym) == self.role.ident
    when String
      return Role.get_ident(role_array_or_sym.to_sym) == self.role.ident
    when Array
      role_array_or_sym.map!{|role| Role.get_ident(role)}
      return role_array_or_sym.include? self.role.ident
    end

  end

  def active?
    self.active
  end

  def available_roles
    if assistant
      self.role.descendants
    else
      self.role.self_and_descendants
    end
  end

  def me? id
    self.id == id
  end

  def guest?
    return true if self.role.blank?
    self.role.to_sym == :guest
  end

  def my_users
    user = self.assistant ? self.parent : self
    User.find(user.self_and_sub_user_ids)
  end

  def my_user_ids
    user = self.assistant ? self.parent : self
    user.self_and_sub_user_ids

  end

  def my_user? user_id
    return true if user_id == self.id
    user_id = user_id.to_i
    @user_ownerships_cache ||= {}
    if @user_ownerships_cache[user_id].blank?
      @user_ownerships_cache[user_id] = my_user_ids.include? user_id
    else
      @user_ownerships_cache[user_id]
    end
  end


  def self_and_sub_user_ids
    if @allowed_user_ids.blank? 
      @allowed_user_ids = []
      regulllar_or_helper = self
      if self.assistant
        Rails.logger.debug("Потребителя #{self.login} е помощник, затова взимаме неговият родител #{self.parent.login} (#{self.parent.id})")
        regulllar_or_helper = User.where(:id => self.parent).includes(:role => [:translations]).first
      end
    
      roles_on_same_level = case self.role.to_sym
      when :team_manager
        :team_manager
      when :manager
        :manager
      else
        false
      end

      @allowed_user_ids = regulllar_or_helper.self_and_descendants.includes(:role).collect do |child|
        # в случайте когато сме помощник - махаме другите manager-и които са на нашето ниво и не сме ние
        if (self.assistant and child.role?(roles_on_same_level) and !me?(child.id))
          # aко ние сме му шефа го оставяме
          Rails.logger.debug "Ние сме асистенти, трябва да махнем съседните на нас #{roles_on_same_level}"
          (child.parent && me?(child.parent.id) ) ? child.id :  nil
        else
          child.id
        end
      end.compact

      # ако аз съм асистент имам правата на шефа си.
      if self.assistant
        @allowed_user_ids << self.parent_id
      end

      Rails.logger.debug("Тези userи са мой #{@allowed_user_ids.inspect} а ние сме #{self.id}")
    end
    @allowed_user_ids
  end

  def sells_for_contact contact
    user_ids = self.self_and_sub_user_ids.collect{|user_id| user_id}
    SellDocument.where({
        :user_id.in => user_ids,
        :contact_id => contact.id
      })
  end


  def buys_for_contact contact
    user_ids = self.self_and_sub_user_ids.collect{|user_id| user_id}

    Buy.where({
        :user_id.in => user_ids,
        :contact_id => contact.id}
    )
  end

  def projects_for_contact contact
    contact.projects(
      :include => [
        :user => [],
        :address => Address.get_includes,
        :status => []
      ]
    )
  end

  # TODO: ASK - тест + self_...
  def get_bosses
    # self_and_
    self.ancestors
  end

  def remove_contact contact
    user_ids_allowed_for_delete = self.my_user_ids
    Project.destroy_all(:user_id => user_ids_allowed_for_delete, :contact_id => contact.id)
    Sell.destroy_all(:user_id => user_ids_allowed_for_delete, :client_id => contact.id)
    Buy.destroy_all(:conditions => {:contact_id => contact.id, :user_id.in => user_ids_allowed_for_delete})
    
    ContactsUser.delete_all(:contact_id => contact.id, :user_id => user_ids_allowed_for_delete)
    
    contact.reload
    if contact.users.size == 0
      contact.destroy
    end

    self.save
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end
  
  private

  def set_name
    real_name = self.display_name(:full)
    
  end

end

