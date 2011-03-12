# == Schema Information
#
# Table name: keywords
#
#  id                :integer(4)      not null, primary key
#  tag               :string(255)
#  patern            :string(255)
#  as                :string(255)
#  active            :boolean(1)
#  validation_method :string(255)
#  values            :integer(4)
#  kind_of_search    :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

class Keyword < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 20
  translates :name

  DISPLAY_AS = {
    I18n::t("Текстова кутия", :scope => [:keywords]) => "string",
    I18n::t("Календар дата", :scope => [:keywords]) => "calendar",
    I18n::t("Единичен избор - select", :scope => [:keywords]) => "select",
    I18n::t("Множествен избор - checkboxes", :scope => [:keywords]) => "check_boxes",
    I18n::t("Mножествен избор - select", :scope => [:keywords]) => "multiple_select",
    I18n::t("Да/Не", :scope => [:keywords]) => "boolean",
    I18n::t("Календар с месеци и години", :scope => [:keywords]) => "month_calendar",
    I18n::t("Календар с година", :scope => [:keywords]) => "year_calendar",
  }
  
  PATERNS = %w(
Integer
String 
Date 
PropertyFunction 
PropertyCategoryLocation 
ConstructionType 
StandartChoice 
ExposureType 
Furnish
HeatingType
InfrastructureType 
ApartmentType
PropertyLocation 
RoadType 
FenceType
  )
  KIND_OF_SEARCH = {
    "Интервал от - до" => "range",
    "Точна стойност" => "exact",
    "Изброени стойности" => "multiple"
  }
  # --- Тези се използват само  в номеклатурата да се изнесат!!!

  #  KIND_OF_SEARCH = {
  #    :range => 'range',
  #    :multiple => 'multiple',
  #    :exact => 'exact',
  #  }
  #
  #  AS = {
  #    :calendar => 'calendar',
  #    :string => 'string',
  #    :month_calendar => 'month_calendar',
  #  } # използва се в хелпер-а

  validate :name, :presence => true
  validate :as, :presence => true
  validate :patern, :presence => true
  
  has_and_belongs_to_many :validation_types
  
  has_many :keywords_property_types, :dependent => :destroy
  has_many :property_types, :through => :keywords_property_types
  
  has_many :keywords_sells, :order => :position
  has_many :sells, :through => :keywords_sells
  

  
  def position(for_property_type_id)
    logger.debug(">>>>>>>>>>>>>>>>>>> Deprecated usage of keyword.position - check search_criteria for example how to use update")
    for_property_type_id = for_property_type_id.to_i
    # ако си дошъл тук по-преследването на многото заявки, да знаеш, че няма да е лесно да се оправят, както вече започваш да се досещаш
    # кеширане на позицията някъде?!
    matched = self.keywords_property_types(true).select do |keyword_property_type|
      keyword_property_type.property_type_id == for_property_type_id
    end
    raise "Немога да намеря имот за property_type_id #{for_property_type_id} за кл. дума #{self.name} във \n
    keywords_property_types: #{self.keywords_property_types.inspect}

-----
    this keyword: #{self.inspect}
    имотите на тази дума: #{self.property_types.inspect}\n
    " if matched.nil? || matched.empty?

    matched.first.position
  end


  def keywords_property_type(property_type_id)
    self.keywords_property_types.select{|t| t.property_type_id.to_i == property_type_id.to_i}.first
  end
  
  def position= property_type_id, position
    o = self.keywords_property_type(property_type_id)
    o.position = position
    o.save
  end

  def <=> keyword
    self.tag <=> keyword.tag
  end
  
end