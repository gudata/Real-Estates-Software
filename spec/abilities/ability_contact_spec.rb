require 'spec_helper'
#require 'wirble'
#Wirble.init
#Wirble.colorize


#def login(u = nil)
#  user = User.make(u)
#  assert UserSession.create(user)
#  user
#end

describe Ability do

  include AbilityHelperMethods
  before(:each) do
    begin
      # Правим отборите
      @teams =
        {
          :team_1 => make_team(:team_1),
          :team_2 => make_team(:team_2)
        }

      # Паравим контакти на потребителите
      # Всеки клиент е и контакт
      @contacts =
        {
          :team_1_cleints => make_contacts_for_team_users(@teams[:team_1]),
          :team_2_cleints => make_contacts_for_team_users(@teams[:team_2])
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
      
    rescue ActiveRecord::RecordInvalid => invalid
      raise invalid.record.errors.full_messages.inspect
    end
  end

  it "Мениджър, Мениджър Екип и Консултант могат да създават контакти" do
    [:new, :create, :check].each do |action|
      @teams[:team_1][:user_manager][:ability].should have_access(action, Contact)
      @teams[:team_1][:user_team_manager][:ability].should have_access(action, Contact)
      @teams[:team_1][:user_consultant][:ability].should have_access(action, Contact)
    end
  end
  
  it "Мениджър, Мениджър Екип и Консултант могат да редактират собствените си контакти " do
    [:edit, :update, :tab_projects, :tab_sells, :tab_buys, :show].each do |action|
        @teams[:team_1][:user_manager][:ability].should have_access(action, @teams[:team_1][:user_manager][:user].contacts.first)
        @teams[:team_1][:user_team_manager][:ability].should have_access(action, @teams[:team_1][:user_team_manager][:user].contacts.first)
        @teams[:team_1][:user_consultant][:ability].should have_access(action, @teams[:team_1][:user_consultant][:user].contacts.first)
    end
  end


  it "Мениджър, Мениджър Екип и Консултант могат да добавят съществуващи контакти към своите" do
    [:add].each do |action|
      @teams[:team_1][:user_manager][:ability].should have_access(action, @teams[:team_1][:user_manager][:user].contacts.first)
      @teams[:team_1][:user_manager][:ability].should have_access(action, @teams[:team_1][:user_team_manager][:user].contacts.first)
      @teams[:team_1][:user_manager][:ability].should have_access(action, @teams[:team_1][:user_consultant][:user].contacts.first)
      @teams[:team_1][:user_team_manager][:ability].should have_access(action, @teams[:team_1][:user_manager][:user].contacts.first)
      @teams[:team_1][:user_team_manager][:ability].should have_access(action, @teams[:team_1][:user_team_manager][:user].contacts.first)
      @teams[:team_1][:user_team_manager][:ability].should have_access(action, @teams[:team_1][:user_consultant][:user].contacts.first)
      @teams[:team_1][:user_consultant][:ability].should have_access(action, @teams[:team_1][:user_manager][:user].contacts.first)
      @teams[:team_1][:user_consultant][:ability].should have_access(action, @teams[:team_1][:user_team_manager][:user].contacts.first)
      @teams[:team_1][:user_consultant][:ability].should have_access(action, @teams[:team_1][:user_consultant][:user].contacts.first)
    end
  end

  it "Мениджър, Мениджър Екип и Консултант не могат да редактират контактите на другите" do
    [:edit, :update, :tab_projects, :tab_offers, :tab_buys].each do |action|
      @teams[:team_1][:user_manager][:ability].should_not have_access(action, @teams[:team_1][:user_team_manager][:user].contacts.first)
      @teams[:team_1][:user_manager][:ability].should_not have_access(action, @teams[:team_1][:user_consultant][:user].contacts.first)
      @teams[:team_1][:user_team_manager][:ability].should_not have_access(action, @teams[:team_1][:user_manager][:user].contacts.first)
      @teams[:team_1][:user_team_manager][:ability].should_not have_access(action, @teams[:team_1][:user_consultant][:user].contacts.first)
      @teams[:team_1][:user_consultant][:ability].should_not have_access(action, @teams[:team_1][:user_manager][:user].contacts.first)
      @teams[:team_1][:user_consultant][:ability].should_not have_access(action, @teams[:team_1][:user_team_manager][:user].contacts.first)
      
    end
  end

  it "Мениджър, Мениджър Екип и Консултант могат да редактират и преглеждат споделен контакт, на който и те са собственици" do
    [:edit, :update, :show].each do |action|
      @teams[:team_1][:user_manager][:ability].should have_access(action, @shared_contact)
      @teams[:team_1][:user_team_manager][:ability].should have_access(action, @shared_contact)
      @teams[:team_1][:user_consultant][:ability].should have_access(action, @shared_contact)
    end
  end


   it "Партньор и Гост нямат достъп до контакти" do
    @teams[:team_1][:user_guest][:ability].should_not have_access(:manage, Contact)
    @teams[:team_2][:user_partner][:ability].should_not have_access(:manage, Contact)
  end

end