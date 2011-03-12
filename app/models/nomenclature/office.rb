class Office < ActiveRecord::Base
  #  attr_accessible :address_id, :mobile_phone, :phone, :fax
  cattr_reader :per_page
  @@per_page = 10

  translates :name, :description
  validate :name, :presence => true

  scope :active, lambda {
    where(:active => true)
  }

  belongs_to :address, :dependent => :destroy
  accepts_nested_attributes_for :address, :allow_destroy => true
  has_many :users

  default_scope :include => :translations
end


# == Schema Information
#
# Table name: offices
#
#  id           :integer(4)      not null, primary key
#  address_id   :integer(4)
#  mobile_phone :string(255)
#  phone        :string(255)
#  fax          :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  active       :boolean(1)
#

