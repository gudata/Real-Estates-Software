class City < ActiveRecord::Base

  cattr_reader :per_page
  @@per_page = 10;

  translates :name, :description
  # TODO
  #, :place_type
  validate :name, :presence => true
  validate :kind, :presence => true


  belongs_to :municipality
  has_many :quarters

  default_scope :include => :translations, :order => "city_translations.name asc"

  def name_with_type
    "#{I18n::t(kind, :scope => [:place_types])} #{self.name}"
  end
end


# == Schema Information
#
# Table name: cities
#
#  id              :integer(4)      not null, primary key
#  district_id     :integer(4)
#  municipality_id :integer(4)
#  place_type      :string(255)
#  kind            :integer(4)
#  position        :integer(4)
#  ekatte          :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#

