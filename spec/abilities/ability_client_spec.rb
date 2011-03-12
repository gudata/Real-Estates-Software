require 'spec_helper'
#require 'wirble'
#Wirble.init
#Wirble.colorize

 

describe Ability, "Права при работа с клиенти / " do
  include AbilityHelperMethods
  before(:each) do
    begin
      # Правим отборите
      @teams = 
        {
          :team_1 => make_team(:team_1),
          :team_2 => make_team(:team_2)
        }

      # Паравим клиенти на потребителите на отборите
      # Всеки клиент е и контакт
      @clients =
        {
          :team_1_cleints => make_offers_for_team_contacts("Project", @teams[:team_1]),
          :team_2_cleints => make_offers_for_team_contacts("Project", @teams[:team_2])
        }

      # Правим споделен контакт, един контакт с много собственици
      @shared_contact = Contact.make(:users =>
        [
          @teams[:team_1][:user_manager][:user],
          @teams[:team_2][:user_manager][:user],
          @teams[:team_1][:user_team_manager][:user],
          @teams[:team_2][:user_team_manager][:user],
          @teams[:team_1][:user_consultant][:user],
          @teams[:team_2][:user_consultant][:user]
        ]
      )
      
      # Споделения контакт го правим клиент за един от собствениците му
      make_project(@teams[:team_1][:user_manager][:user], @shared_contact)
    rescue ActiveRecord::RecordInvalid => invalid
      raise invalid.record.errors.full_messages.inspect
    end
  end

  it "Всеки може да редактира и преглежда клиент, ако той е негов клиент или контакт" do
    [:edit, :update, :tab_projects, :tab_offers, :tab_buys, :show].each do |action|
      @teams[:team_1][:user_manager][:ability].should have_access(:edit, @shared_contact)
      @teams[:team_2][:user_manager][:ability].should have_access(:edit, @shared_contact)
      @teams[:team_1][:user_team_manager][:ability].should have_access(:edit, @shared_contact)
      @teams[:team_2][:user_team_manager][:ability].should have_access(:edit, @shared_contact)
      @teams[:team_1][:user_consultant][:ability].should have_access(:edit, @shared_contact)
      @teams[:team_2][:user_consultant][:ability].should have_access(:edit, @shared_contact)
    end
  end

  it "Шефовете могат да редактират клиентите на своите подчинени" do
    @teams[:team_1][:user_manager][:ability].should have_access(:edit, @teams[:team_1][:user_team_manager][:user].contacts.first)
    @teams[:team_1][:user_manager][:ability].should have_access(:edit, @teams[:team_1][:user_consultant][:user].contacts.first)
    @teams[:team_1][:user_team_manager][:ability].should have_access(:edit, @teams[:team_1][:user_consultant][:user].contacts.first)
  end

  it "Подчинените не могат да редактират клиентите на своите шефове, ако не са и техни контакти или клиенти" do
    @teams[:team_1][:user_team_manager][:ability].should_not have_access(:edit, @teams[:team_1][:user_manager][:user].contacts.first)
    @teams[:team_1][:user_consultant][:ability].should_not have_access(:edit, @teams[:team_1][:user_team_manager][:user].contacts.first)
    @teams[:team_1][:user_consultant][:ability].should_not have_access(:edit, @teams[:team_1][:user_manager][:user].contacts.first)
  end

  it "Шефовете не могат да редактират клиентите на шефове и подчинени от други отбори" do
    @teams[:team_1][:user_manager][:ability].should_not have_access(:edit, @teams[:team_2][:user_manager][:user].contacts.first)
    @teams[:team_1][:user_manager][:ability].should_not have_access(:edit, @teams[:team_2][:user_team_manager][:user].contacts.first)
  end

  it "Партньор и Гост нямат достъп до клиенти" do
    @teams[:team_1][:user_guest][:ability].should_not have_access(:manage, Contact)
    @teams[:team_2][:user_partner][:ability].should_not have_access(:manage, Contact)
  end

end