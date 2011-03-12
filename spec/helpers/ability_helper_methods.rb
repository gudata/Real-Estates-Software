module AbilityHelperMethods  

  def make_user(role = :manager, parent = nil, assistant = false, in_team = nil)
    User.make(:role => Role.make(role),
      :parent => parent,
      :assistant => assistant,
      :team => in_team
    )
  end

  def make_contact user
    contact = Contact.make(:users => [user], :phones => [Phone.make])    
    return contact
  end

  def offer_type(type = :sell)
    case type
    when :sell
      OfferType.make(:name => "Продава", :category => 2)
    when :buy
      OfferType.make(:name => "Купува", :category => 1)
    else
      raise "Не е дефиниран коректен тип на офертата"
    end
  end

  def make_sell(user, contact, property_type = :apartment)
    Sell.make(
      :user => user,
      :contact => contact,
      :address => Address.make,
      :property_type => PropertyType.make(property_type),
      :offer_type => offer_type(:sell),
      :status => Status.make,
      :source => Source.make,
      :source_value => Sham.name,
      :keywords => [Keyword.make]
    )
  end

  def make_project (user, contact)
    Project.make(:user => user,
      :contact => contact,
      :status => Status.make,
      :contact_person => Sham.name,
      :contact_person_phone => Sham.phone,
      :finish_date => Time.now,
      :furnish => Furnish.make,
      :source => Source.make,
      :project_stage => ProjectStage.make,
      :property_category_location => PropertyCategoryLocation.make
    )    
  end

  # Прави отбор с потребители
  # TODO - Трябва да се добави възможност за правене на вложени отбори
  # за да може да се проверява пълната йерахия на правата
  # Достъп до user и неговите обекти хеш team[:team_manager][:user].contacts, team[:team_manager][:user].projects
  # Достъп до Ability хеш team[:team_manager][:ability]
  def make_team name
    new_team = Team.make(name)
    team = {}

      add_user_to_team!(team, :user_manager, :manager, nil, false, new_team)
      add_user_to_team!(team, :user_manager_asistent, :manager, team[:user_manager][:user], true, new_team)
      add_user_to_team!(team, :user_team_manager, :team_manager, team[:user_manager][:user], false, new_team)
      add_user_to_team!(team, :user_team_manager_assistent, :team_manager, team[:user_team_manager][:user], true, new_team)
      add_user_to_team!(team, :user_consultant, :consultant, team[:user_team_manager][:user], false, new_team)
      add_user_to_team!(team, :user_partner, :partner, team[:user_manager][:user], false, new_team)
      add_user_to_team!(team, :user_guest, :guest, team[:user_consultant][:user], false, new_team)

      # to get the awsome_nested_set recognize the children
      team.each_value do |user|
        user[:user].reload
      end

      return team
  end

  # Добавя потребител към отбор
  # При ръчно добавяне трябва потребителското име за хеша да е уникално
  # TODO - Да проверява дали потребителското име е уникално
  def add_user_to_team!(team, user_name, role, parent = nil, assistant = false, in_team = nil)
    begin
      raise ArgumentError, "В този отбор вече има потребител с име #{user_name}" if team.has_key?(user_name)
      user = make_user(role, parent, assistant, in_team)
      team[user_name]  =  {:user => user, :ability => Ability.new(user)}
    rescue ActiveRecord::RecordInvalid => invalid
      raise invalid.record.errors.full_messages.inspect
    end    
  end

  def make_contacts_for_team_users(team)
    contacts = []
    begin
      team.each_value do |user|
        contacts << make_contact(user[:user])
      end
    rescue ActiveRecord::RecordInvalid => invalid
      raise invalid.record.errors.full_messages.inspect
    end
  end

  def make_offers_for_team_contacts(offer_object, team)
    offers = []
    begin
      raise "Няма потребители в отбора" if team.blank?
      team.each_value do |user|      
        make_contact(user[:user]) if user[:user].contacts.empty?
        user[:user].contacts.each do |contact|
          offers << offer_object.constantize.make(:user => user[:user], :contact => contact)
        end
      end
    rescue ActiveRecord::RecordInvalid => invalid
      raise invalid.record.errors.full_messages.inspect
    end
  end

end