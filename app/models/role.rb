class Role < ActiveRecord::Base
  acts_as_nested_set

  has_many :users
  
  translates :name

#  default_scope :include => :translations
  
  IDS = [
    {:name => "Мениджър", :value => 0, :parent => nil},
    {:name => "Мениджър екип", :value => 1, :parent => 0},
    {:name => "Консултант", :value => 2, :parent => 1},
    {:name => "Партньор", :value => 3, :parent => nil},
    {:name => "Гост", :value => 4, :parent => nil},
  ]

  SYM_TYPE = {
    :manager => 0,
    :team_manager => 1,
    :consultant => 2,
    :partner => 3,
    :guest => 4,
  }


  TYPE_SYM = SYM_TYPE.invert
  
  def to_sym 
    TYPE_SYM[self.ident]
  end

  def to_s
    self.to_sym.to_s.humanize
  end

  def Role.to_sym ident
    TYPE_SYM[ident]
  end

  def Role.get_ident ident
    SYM_TYPE[ident]
  end

  def Role.get(sym)
    Role.find_by_ident(SYM_TYPE[sym.to_sym]) || raise("Cant find #{sym} role")
  end
  
end

# == Schema Information
#
# Table name: roles
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  ident      :integer(4)
#  parent_id  :integer(4)
#  lft        :integer(4)
#  rgt        :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

