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
#    @manager_user = User.make(:role => Role.make(:manager))
#    @team_manager_user = User.make(:role => Role.make(:team_manager), :parent => @manager_user)
#    @consultant_user = User.make(:role => Role.make(:consultant), :parent => @team_manager_user)
#    @partner_user = User.make(:role => Role.make(:partner), :parent => @manager_user)
#    @guest_user = User.make(:role => Role.make(:guest), :parent => @manager_user)
#
#    # to get the awsome_nested_set recognize the children
#    @manager_user.reload
#
#    @team_manager_user.reload
#    @consultant_user.reload
#
#    @manager = Ability.new(@manager_user)
#    @team_manager = Ability.new(@team_manager_user)
#    @consultant = Ability.new(@consultant_user)
#    @partner  = Ability.new(@partner_user)
#    @guest  = Ability.new(@guest_user)
#
#    @manager_contact = Contact.make(:users => [@manager_user])
#    @team_manager_contact = Contact.make(:users => [@team_manager_user])
#    @consultant_contact = Contact.make(:users => [@consultant_user])
#
#    @manager_sell = Sell.make(:user => @manager_user,
#      :property_type => PropertyType.make,
#      :sell_type => SellType.make
#    )
#    @team_manager_sell = Sell.make(:user => @team_manager_user,
#      :property_type => PropertyType.make,
#      :sell_type => SellType.make
#    )
#    @consultant_manager_sell = Sell.make(:user => @consultant_user,
#      :property_type => PropertyType.make,
#      :sell_type => SellType.make
#    )
  end

  it "Всички мениджъри, мениджъри на екипи и консултанти могат да преглеждат оферти" do
    pending ".........."
  end

  it "Всеки може да редактира собствените си оферти" do
    pending ".........."
  end

  it "Всеки може да добавя оферти към своите контакти" do
    pending ".........."
  end

  it "Всеки може да редактира офертите на своите подчинени" do
    pending ".........."
  end

end