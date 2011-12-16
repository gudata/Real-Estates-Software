class Ability
=begin
Some inline documentation

  alias_action :index, :show, :to => :read
  alias_action :new, :to => :create
  alias_action :edit, :to => :update

=end
  include CanCan::Ability


  # help http://github.com/ryanb/cancan/blob/master/lib/cancan/ability.rb

  attr_reader :user
  def initialize(user)
    Rails.logger.debug("--- Start Access Control ---------------------------------------- ")
    @user = @real_user = user
    @user = @real_user.parent if @real_user.assistant == true
    
#    if Rails.env != 'development'
#      can :manage, :all
#      return
#    end
    
    if user.role?(:manager) 
      can :manage, :all
      return
    else
      cannot :manage, :all
    end
    
    define_navigation
    
    define_user if @user.role?([:manager, :team_manager])
    if @user.role?([:manager, :team_manager, :consultant])
      define_contact
      define_contact_offers
      #      define_inspection
    end

    can :set_owner, [User] do |edit_user|
      Rails.logger.debug("AC: set_owner, User")
      if @user.role?([:guest, :consultant, :partner])
        false
      else
        self_change = @user.id != edit_user.id
        (
          @user.my_user?(edit_user.id) and @user.role?([:manager, :team_manager])
        ) and
          ( @user.assistant == false and self_change ) or edit_user.guest?
      end
    end

    can :set_owner, [Project, Sell, Buy] do |object|
      Rails.logger.debug("AC: set_owner, Project, Sell")
      Rails.logger.debug "Децата+нас преди сметките са: #{@user.self_and_sub_user_ids.inspect}"
      result = (
        @user.my_user?(object.user_id.to_i) and @user.role?([:manager, :team_manager, :consultant])
      )
      Rails.logger.debug "Проект/Обява user_id: #{object.user_id} разрешено: #{result}"

      result
    end

    can :quick_manage, [Inspection]  do |object|
      @user.my_user?(object.user_id)
    end
    Rails.logger.debug("--- END Access Control ---------------------------------------- ")
  end

  def define_navigation
    Rails.logger.debug("AC: navigation")
    can :index, Navigation # if  @user.role?([:manager, :team_manager, :consultant, :guest, :partner])
    # самите номеклатури
    can :nomenclature, Navigation if @user.role?([:manager, :team_manager])
    # списъка с номеклатурите
    can :nomenclatures, Navigation if @user.role?([:manager, :team_manager])
    can :contacts, Navigation if @user.role?([:manager, :team_manager, :consultant])
    can :guest_screen, Navigation if @user.role?(:guest)
  end

  def define_user
    can [:index, :help], User do |subject|
      true
    end

    can [:new, :create], User do |subject|
      Rails.logger.debug("define_user за new/create #{@user.role.name}")
      @user.role?([:manager, :team_manager])
    end
    
    can [:edit, :update, :show], User do |subject|
      if subject
        Rails.logger.debug("define_user за edit, update, show")
        # Ако е гост, всеки може да си го вземе в екипа
        if subject.guest?
          true
        else
          # може да го редактира само ако иска да редактира себе си
          # може да го редактира и ако е по-главна роля
          @user.my_user? subject.id
        end
      end
    end

    can [:destroy, :activate], User do |subject|
      if subject
        Rails.logger.debug("define_user за destroy, activate")
        # Ако е гост, всеки може да си го вземе в екипа
        if subject.guest?
          true
        else
          # може да трие всички без себе си.
          @user.id != subject.id and @user.my_user?(subject.id)
        end
      end
    end

    can :set_role, User do |edit_user|
      if (@user.role?([:manager, :team_manager]))
        if (@user.assistant == false and @user.id != edit_user.id)
          true
        elsif  @user.id == edit_user.id
          false
        else
          true
        end
      else
        false
      end
    end
    
    can :set_assistant, User do |edit_user|
      @user.role?([:manager, :team_manager]) and  (@user.assistant == false and @user.id != edit_user.id)
    end

  end

  def define_contact
    can [:new, :create, :check, :add, :show_offers], Contact do |subject|
      Rails.logger.debug("  AC: check contact new/create/check/add contact_id: #{subject.id}")
      # Няма значение дали е нов запис,  клиент или контакт, гледаме само ролята
      @user.role?([:manager, :team_manager, :consultant])
    end

    can [:edit, :tab_projects, :tab_sells, :tab_buys, :tab_contact, :update, :show, :destroy, :index_clients, :index_contacts, :read], Contact do |subject|
      # Контакта съществува и може да е клиент и/или контакт
      result = check_access subject
      #Rails.logger.debug("  AC: #{result} - check contact :edit, :tabe_projects, ..., contact_id: #{subject.id}")
      result
    end

    can :destroy, Contact do |subject|
      # Контакта съществува и може да е клиент и/или контакт
      Rails.logger.debug("  AC: check contact destroy ")
      subject.users.include?(@user)
    end
    
    can :peek_contact, Contact do |subject|
      Rails.logger.debug("AC: peek_contact #{subject.id}")
      subject ? check_access(subject) : false
    end
  end

  def check_access contact
    role_condition = @user.role?([:manager, :team_manager, :consultant])

    return true if contact.blank? and role_condition

    contact.users.all.each do |contact_user|
      #      ContactsUser.where(:contact_id => contact.id).all(:select => 'user_id').each do |contact_user|
      if contact.is_client_for_user?(contact_user.id)
        # Клент е и трябва да съм му собственик, шеф на собственика или помощник на шефа на собственика за да го редактирам
        return true if (@user.my_user?(contact_user.id) and @user.role?([:consultant, :manager, :team_manager]))
        # @user.my_user_ids.include? contact_user.id or
      else
        # Не е клиент и трябва да съм собственик на КОНТАКТА за го редактирам
        # @user.my_user_ids.include?
        return true if @real_user.id == contact_user.id
      end
    end

    false
  end

  def define_contact_offers
    check_subjects = [Sell, SellDocument, Project, Buy, SearchCriteria, AddressDocument, Attachment]

    can [:index, :new, :create, :destroy, :show,
      :tab_project_sells,
      :user_projects,
      :user_offers,
      :read,
      :property_type_keywords, # Buy
      :tab_search_results, # Buy
      :show_attachments, # Buy
      :tab_basic_data, # Buy
    ], check_subjects do |subject|
      result = @user.role?([:manager, :team_manager, :consultant])
      Rails.logger.debug("AC: #{result} - defining_contact_offers index,show... object:" + (subject ? "on #{subject.class} #{subject.id}" : ""))
      result
    end
    
    can [:edit, :update, :criteria_search_result, :buy_search_result, :change_buy_status], check_subjects do |subject|
      Rails.logger.debug("AC: defining_contact_offers :edit, :update... object:" + (subject ? "on #{subject.class} #{subject.id}" : ""))
      @user.my_user?(subject.user_id) and @user.role?([:manager, :team_manager, :consultant])
    end

    can [:peek_offer_from_contact], check_subjects do |subject|
      Rails.logger.debug("AC: defining_contact_offers :peek object:" + (subject ? "on #{subject.class} #{subject.id}" : ""))
      subject and (
        (subject.respond_to?(:status) and subject.status.client_visible)  or
          (@user.my_user?(subject.user_id) and @user.role?([:manager, :team_manager, :consultant]))
      )
    end

    can :peek_project, Project do |subject|
      Rails.logger.debug("AC: peek_project")
      subject and @user.my_user?(subject.user_id) and @user.role?(:manager, :team_manager, :consultant)
    end

  end

  # helper method
  def self.for_user(user_id)
    Ability.new(User.find(user_id))
  end
end


__END__
reload!
a = Ability.for_user(4)
b = Buy.where(:number => 21).first
p = Project.find(48)
a.user.role?([:manager, :team_manager, :consultant])
a.can? :show, p
