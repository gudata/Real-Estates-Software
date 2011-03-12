class Team < ActiveRecord::Base
  #  attr_accessible :active
  cattr_reader :per_page
  @@per_page = 10

  translates :name, :description
  
  validate :name, :presence => true

  scope :active, lambda {
    where(:active => true)
  }
  has_many :users

  default_scope :include => :translations
  
  def self.get_team_users(tem_id)
    User.find_all_by_team_id(tem_id)
  end
  
end

# == Schema Information
#
# Table name: teams
#
#  id         :integer(4)      not null, primary key
#  active     :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

