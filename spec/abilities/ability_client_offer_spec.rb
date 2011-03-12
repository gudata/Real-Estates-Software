require 'spec_helper'
#require 'wirble'
#Wirble.init
#Wirble.colorize



describe Ability, "Права при работа с оферти на клиент / " do
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
        :team_1_cleints => {
          :projects => make_offers_for_team_contacts("Project", @teams[:team_1]),
          :sells => make_offers_for_team_contacts("Sell", @teams[:team_1])
        },
        :team_2_cleints =>{
          :projects => make_offers_for_team_contacts("Project", @teams[:team_2]),
          :sells => make_offers_for_team_contacts("Sell", @teams[:team_2])
        }
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

      # Споделения контакт го правим клиент за всичките му собствениците
      # като му добавяме проект и оферта продава за всеки собственик
      @sells = []
      @projects = []
      @teams.each_value do |team|
        team.each_value do |user|          
          @sells << Project.make(:user => user[:user], :contact => @shared_contact)
          @projects << Sell.make(:user => user[:user], :contact => @shared_contact)
        end
      end
    rescue ActiveRecord::RecordInvalid => invalid
      raise invalid.record.errors.full_messages.inspect
    end
  end

  it "Всеки който има достъп до клиента може да преглежда офертите му и да ги печата" do
    [:show].each do |action|
      @teams.each_value do |team|
        team.each_value do |user|
          break if user[:user].role?(:guest) or user[:user].role?(:partner)
          user[:ability].should have_access(:peek_contact, @shared_contact)
          user[:ability].should have_access(action, @sells.first)
          user[:ability].should have_access(action, @projects.first)
        end
      end
    end
  end

  it "Всеки който има достъп до клиента може да редактира добавените от него оферти" do
    @teams.each_value do |team|
      team.each_value do |user|
          break if user[:user].role?(:guest) or user[:user].role?(:partner)
          user[:ability].should have_access(:peek_contact, @shared_contact)
          user[:ability].should have_access(:edit, @shared_contact.sells.all(
              :conditions => {:user_id => user[:user].id}).first
          )
          user[:ability].should have_access(:edit, @shared_contact.projects.all(
              :conditions => {:user_id => user[:user].id}).first
          )
      end
    end
  end
  

  it "Всички шефове могат да редактират офертите към клиент добавен от техните подчинени" do
    @teams[:team_1][:user_manager][:ability].should have_access(:edit, @teams[:team_1][:user_team_manager][:user].contacts.first.sells.first)
    @teams[:team_1][:user_manager][:ability].should have_access(:edit, @teams[:team_1][:user_consultant][:user].contacts.first.sells.first)
    @teams[:team_1][:user_team_manager][:ability].should have_access(:edit, @teams[:team_1][:user_consultant][:user].contacts.first.sells.first)
  end

  it "Никой не може да редактира оферта към контакт, която не е добавена от него или негов подчинен" do
    @teams[:team_1][:user_manager][:ability].should_not have_access(:edit, @teams[:team_2][:user_manager][:user].contacts.first.sells.first)
    @teams[:team_1][:user_manager][:ability].should_not have_access(:edit, @teams[:team_2][:user_team_manager][:user].contacts.first.sells.first)
    @teams[:team_1][:user_manager][:ability].should_not have_access(:edit, @teams[:team_2][:user_consultant][:user].contacts.first.sells.first)
    @teams[:team_1][:user_team_manager][:ability].should_not have_access(:edit, @teams[:team_2][:user_manager][:user].contacts.first.sells.first)
    @teams[:team_1][:user_team_manager][:ability].should_not have_access(:edit, @teams[:team_2][:user_team_manager][:user].contacts.first.sells.first)
    @teams[:team_1][:user_team_manager][:ability].should_not have_access(:edit, @teams[:team_2][:user_consultant][:user].contacts.first.sells.first)
    @teams[:team_1][:user_consultant][:ability].should_not have_access(:edit, @teams[:team_2][:user_manager][:user].contacts.first.sells.first)
    @teams[:team_1][:user_consultant][:ability].should_not have_access(:edit, @teams[:team_2][:user_team_manager][:user].contacts.first.sells.first)
    @teams[:team_1][:user_consultant][:ability].should_not have_access(:edit, @teams[:team_2][:user_consultant][:user].contacts.first.sells.first)
  end

  it "Партньор и Гост нямат достъп до клиента и не могат да редактират офертите му" do
    @teams[:team_1][:user_guest][:ability].should_not have_access(:edit, @teams[:team_2][:user_manager][:user].contacts.first.sells.first)
    @teams[:team_1][:user_partner][:ability].should_not have_access(:edit, @teams[:team_2][:user_team_manager][:user].contacts.first.sells.first)
  end

end