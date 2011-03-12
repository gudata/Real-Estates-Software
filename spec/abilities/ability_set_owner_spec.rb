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
  context "Работа с потребители" do
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
        #      make_project(@teams[:team_1][:user_manager][:user], @shared_contact)
      rescue ActiveRecord::RecordInvalid => invalid
        raise invalid.record.errors.full_messages.inspect
      end
    end

    it "Смяна собственик на потребител" do
      @teams[:team_1][:user_manager][:ability].should_not have_access(:set_owner, @teams[:team_1][:user_manager][:user])
      @teams[:team_1][:user_manager][:ability].should have_access(:set_owner, @teams[:team_1][:user_team_manager][:user])
      @teams[:team_1][:user_manager][:ability].should have_access(:set_owner, @teams[:team_1][:user_consultant][:user])
      @teams[:team_1][:user_manager][:ability].should have_access(:set_owner, @teams[:team_1][:user_partner][:user])
      @teams[:team_1][:user_manager][:ability].should have_access(:set_owner, @teams[:team_1][:user_guest][:user])

      @teams[:team_1][:user_team_manager][:ability].should_not have_access(:set_owner, @teams[:team_1][:user_manager][:user])
      @teams[:team_1][:user_team_manager][:ability].should_not have_access(:set_owner, @teams[:team_1][:user_team_manager][:user])
      @teams[:team_1][:user_team_manager][:ability].should have_access(:set_owner, @teams[:team_1][:user_consultant][:user])
      @teams[:team_1][:user_team_manager][:ability].should_not have_access(:set_owner, @teams[:team_1][:user_partner][:user])
      @teams[:team_1][:user_team_manager][:ability].should have_access(:set_owner, @teams[:team_1][:user_guest][:user])

      [
        @teams[:team_1][:user_guest],
        @teams[:team_1][:user_consultant],
        @teams[:team_1][:user_partner]
      ].each do |user_ability|
        user = user_ability[:user]
        logged_user = user_ability[:ability]
#        puts "user.role == #{user.role.to_s}"
        logged_user.should_not have_access(:set_owner, @teams[:team_1][:user_manager][:user])
        logged_user.should_not have_access(:set_owner, @teams[:team_1][:user_team_manager][:user])
        logged_user.should_not have_access(:set_owner, @teams[:team_1][:user_consultant][:user])
        logged_user.should_not have_access(:set_owner, @teams[:team_1][:user_partner][:user])
        logged_user.should_not have_access(:set_owner, @teams[:team_1][:user_guest][:user])
      end
    end

    it "Смяна собственик на проект" do
      @teams[:team_1][:user_manager][:ability].should have_access(:set_owner, @teams[:team_1][:user_manager][:user].projects.first)
      @teams[:team_1][:user_manager][:ability].should have_access(:set_owner, @teams[:team_1][:user_team_manager][:user].projects.first)
      @teams[:team_1][:user_manager][:ability].should have_access(:set_owner, @teams[:team_1][:user_consultant][:user].projects.first)

      @teams[:team_1][:user_team_manager][:ability].should_not have_access(:set_owner, @teams[:team_1][:user_manager][:user].projects.first)
      @teams[:team_1][:user_team_manager][:ability].should have_access(:set_owner, @teams[:team_1][:user_team_manager][:user].projects.first)
      @teams[:team_1][:user_team_manager][:ability].should have_access(:set_owner, @teams[:team_1][:user_consultant][:user].projects.first)

      @teams[:team_1][:user_consultant][:ability].should_not have_access(:set_owner, @teams[:team_1][:user_manager][:user].projects.first)
      @teams[:team_1][:user_consultant][:ability].should_not have_access(:set_owner, @teams[:team_1][:user_team_manager][:user].projects.first)
      @teams[:team_1][:user_consultant][:ability].should have_access(:set_owner, @teams[:team_1][:user_consultant][:user].projects.first)

      [:partner, :guest].each do |role|
        @teams[:team_1][:"user_#{role}"][:ability].should_not have_access(:set_owner, @teams[:team_1][:user_manager][:user].projects.first)
        @teams[:team_1][:"user_#{role}"][:ability].should_not have_access(:set_owner, @teams[:team_1][:user_team_manager][:user].projects.first)
        @teams[:team_1][:"user_#{role}"][:ability].should_not have_access(:set_owner, @teams[:team_1][:user_consultant][:user].projects.first)
      end


      @teams[:team_1][:user_manager][:ability].should_not have_access(:set_owner, @teams[:team_2][:user_manager][:user].projects.first)
      @teams[:team_1][:user_manager][:ability].should_not have_access(:set_owner, @teams[:team_2][:user_team_manager][:user].projects.first)
      @teams[:team_1][:user_manager][:ability].should_not have_access(:set_owner, @teams[:team_2][:user_consultant][:user].projects.first)

      @teams[:team_1][:user_team_manager][:ability].should_not have_access(:set_owner, @teams[:team_2][:user_manager][:user].projects.first)
      @teams[:team_1][:user_team_manager][:ability].should_not have_access(:set_owner, @teams[:team_2][:user_team_manager][:user].projects.first)
      @teams[:team_1][:user_team_manager][:ability].should_not have_access(:set_owner, @teams[:team_2][:user_consultant][:user].projects.first)

      @teams[:team_1][:user_consultant][:ability].should_not have_access(:set_owner, @teams[:team_2][:user_manager][:user].projects.first)
      @teams[:team_1][:user_consultant][:ability].should_not have_access(:set_owner, @teams[:team_2][:user_team_manager][:user].projects.first)
      @teams[:team_1][:user_consultant][:ability].should_not have_access(:set_owner, @teams[:team_2][:user_consultant][:user].projects.first)

      [:partner, :guest].each do |role|
        @teams[:team_1][:"user_#{role}"][:ability].should_not have_access(:set_owner, @teams[:team_2][:user_manager][:user].projects.first)
        @teams[:team_1][:"user_#{role}"][:ability].should_not have_access(:set_owner, @teams[:team_2][:user_team_manager][:user].projects.first)
        @teams[:team_1][:"user_#{role}"][:ability].should_not have_access(:set_owner, @teams[:team_2][:user_consultant][:user].projects.first)
      end

    end
  end
end