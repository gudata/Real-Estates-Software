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
  
  before(:each) do
    @manager_user = User.make(:role => Role.make(:manager))
    @team_manager_user = User.make(:role => Role.make(:team_manager), :parent => @manager_user)
    @consultant_user = User.make(:role => Role.make(:consultant), :parent => @team_manager_user)
    @partner_user = User.make(:role => Role.make(:partner), :parent => @manager_user)
    @guest_user = User.make(:role => Role.make(:guest), :parent => @manager_user)

    # to get the awsome_nested_set recognize the children
    @manager_user.reload
    @team_manager_user.reload
    @consultant_user.reload

    @manager = Ability.new(@manager_user)
    @team_manager = Ability.new(@team_manager_user)
    @consultant = Ability.new(@consultant_user)
    @partner  = Ability.new(@partner_user)
    @guest  = Ability.new(@guest_user)
    
  end

  it "Manager има права да редактира всичкo" do
    @manager.should have_access(:manage, :all)
  end

  it "Има достъп до начална страница" do
    @manager.should have_access(:index, Navigation)
    @team_manager.should have_access(:index, Navigation)
    @consultant.should have_access(:index, Navigation)
    @partner.should have_access(:index, Navigation)
    @guest.should have_access(:index, Navigation)
  end
  
  it "Рeдакция на номенклатурите" do
    @manager.should have_access(:nomenclature, Navigation)
    @team_manager.should have_access(:nomenclature, Navigation)
    @consultant.should_not have_access(:nomenclature, Navigation)
    @partner.should_not have_access(:nomenclature, Navigation)
    @guest.should_not have_access(:nomenclature, Navigation)
  end

end