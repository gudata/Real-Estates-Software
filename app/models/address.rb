# == Schema Information
#
# Table name: addresses
#
#  id              :integer(4)      not null, primary key
#  country_id      :integer(4)
#  district_id     :integer(4)
#  municipality_id :integer(4)
#  city_id         :integer(4)
#  quarter_id      :integer(4)
#  street          :string(255)
#  number          :string(255)
#  entrance        :string(255)
#  floor           :integer(4)
#  apartment       :string(255)
#  lat             :float
#  lng             :float
#  created_at      :datetime
#  updated_at      :datetime
#  building        :string(255)
#  floor_type_id   :string(25)
#  street_type_id  :string(25)
#  description     :text
#

class Address < ActiveRecord::Base
  # http://github.com/bhedana/google_maps
  #  acts_as_mappable :default_units => :kms,
  #                       :default_formula => :sphere,
  #                       :distance_field_name => :distance,
  #                       :lat_column_name => :lat,
  #                       :lng_column_name => :lng

  @@per_page = 20

  has_one :office
  has_one :user
  has_one :contact
  belongs_to :country
  belongs_to :district
  belongs_to :municipality
  belongs_to :city
  belongs_to :quarter
  belongs_to :floor_type
  belongs_to :street_type
  
  translates :description
  
  #  default_scope :include =>
  #    [
  #      :country => [:translations],
  #      :district => [:translations],
  #      :municipality => [:translations],
  #      :city => [:translations],
  #      :quarter  => [:translations]
  #    ]

  def self.get_includes
    {
      :city => [:translations],
      :country => [:translations],
      :municipality => [:translations],
      :district => [:translations],
      :translations => [],
    }
  end


  def to_s
    "to_s:" + [self.try(:country).try(:name), self.try(:district).try(:name), self.try(:municipality).try(:name), self.try(:city).try(:name), self.try(:quarter).try(:name), self.street, self.number].compact.join(", ")
  end

  def to_geo_code
    # Geokit::GeoLoc : http://geokit.rubyforge.org/api/geokit-gem/Geokit/GeoLoc.html
    search_for = ''
    if self.lat.blank? && self.lng.blank? 
      street_number = self.number
      street = self.street
      quarter = self.quarter ? self.quarter.name : ""
      city = self.city ? self.city.name : ""
      district = self.district ? self.district.name : ""
      country = self.country ? self.country.name : ""

      if street.blank? && !quarter.blank?
        street = quarter
      end

      search_for += street + ' 'unless street.blank?
      search_for += street_number + ', ' unless street_number.blank?
      search_for += city + ', ' unless city.blank?
      search_for += district + ', ' unless district.blank?
      search_for += country unless country.blank?
    else
      search_for = [self.lat.to_s, self.lng.to_s].join(' ,')
    end
    
    Geokit::Geocoders::GoogleGeocoder.geocode(search_for)
  end

end

