# == Schema Information
#
# Table name: property_types
#
#  id         :integer(4)      not null, primary key
#  active     :boolean(1)
#  position   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class PropertyType < ActiveRecord::Base
#  attr_accessible :active, :position
#  include MongoMapper::Document
  
  cattr_reader :per_page
  @@per_page = 10
  translates :name

  validate :name, :presence => true

  has_many :keywords_property_types, :dependent => :destroy
  accepts_nested_attributes_for :keywords_property_types # this method is defined bellow :)

  has_many :keywords, :through => :keywords_property_types
  accepts_nested_attributes_for :keywords
  has_one :sell

  default_scope :include => :translations

  def keywords_property_types_attributes=(attributes)
    self.reload
    attributes.each do |attribute|
        
      attribute = attribute.last
      
      if attribute[:keyword_id].blank? and !attribute[:id].blank?
        self.keywords_property_types.find(attribute[:id]).delete
      elsif !attribute[:keyword_id].blank? and attribute[:id].blank?
        self.keywords_property_types.build(:keyword_id => attribute[:keyword_id], 
          :position => attribute[:position],
          :style => attribute[:style],
          :end_of_line => attribute[:end_of_line]
        )
      end
    end
    self.save
  end

end