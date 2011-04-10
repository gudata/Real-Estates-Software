module OpenStructCache
  def reload_model(model_class)
    key = get_key(model_class)
    Rails::logger.debug("Презареждане на кеш за #{key}")
    collection = key.constantize.send("all").collect do |object|
      attributes = object.attributes
      attributes.merge!(object.translated_attributes) if object.respond_to? :translated_attributes
      OpenStruct.new(attributes)
    end

    self.storage[key] = collection
  end

  def [] class_name_or_object
    key = get_key(class_name_or_object)
    ::Rails.logger.debug("Cache hit #{key}")
    raise "#{key} is missing in the cache #{@cache.keys.join ', '}" unless key? key
    self.storage[key]
  end

  def init_cache
    Rails.logger.debug "Init cache base method"
    @@models.each do |model_class|
      reload_model(model_class)
    end
  end
end

# кешира направо, без да събира атрибути. подх. само за ак. р. където транслациите са заредени
module DirectCache
  def init_cache
  end
  
  def reload_model(model_class)
    key = get_key(model_class)
    klass = key.constantize
    object = klass.scoped
    Rails.logger.debug "Loading cache for #{key}..."
    if klass.respond_to?(:translates) and klass.translates?
      Rails.logger.debug "  Adding translation in the model for #{klass}"
      object = object.includes(:translations)
      self.storage[key] = object.send("all")
    end
  end

  def [] class_name_or_object
    Rails.logger.debug "Hiting cache for #{class_name_or_object}"
    key = get_key(class_name_or_object)
    reload_model(class_name_or_object) if self.storage[key].blank? or self.storage[key].empty?
    raise "#{key} is missing in the cache #{@cache.keys.join ', '}" unless key? key
    self.storage[key]
  end

  def init_cache
  end

end

module NoCache
  def reload_model(model_class)
    key = get_key(model_class)
    self.storage[key] = key.constantize
  end

  def [] class_name_or_object
    key = get_key(class_name_or_object)
    raise "#{key} is missing in the cache #{@cache.keys.join ', '}" unless key? key
    klass = self.storage[key]
    object = klass.scoped
    if klass.respond_to?(:translates) and klass.translates?
      Rails.logger.debug "Adding translation in the model for #{klass}"
      object = object.includes(:translations)
    end
    object.send("all")
  end

  def init_cache
  end

end

class Cache
  include DirectCache
  #  include NoCache
  #  include OpenStructCache

  @@models = [
    PropertyFunction,
    PropertyCategoryLocation,
    ConstructionType,
    ExposureType,
    Furnish,
    HeatingType,
    InfrastructureType,
    PropertyLocation,
    RoadType,
    FenceType,
    OfferType,
    ContactCategory,
    Sphere,
    RoomType,
    ApartmentType,
    ExposureType,
    Country,
    District,
    Municipality,
    Quarter,
    Source,
    Status,
    PropertyType,
    InternetComunicatorType,
    PhoneType,
    Keyword,
    StandartChoice,
    Municipality,
    #    City, # to many values
    ProjectStage,
    #    StreetType,
    #    FloorType,
    #    CanceledType,
  ]

  cattr_reader :models
  
  def initialize
    @cache = {}
    begin
      init_cache
    rescue
      puts "\n\nНе мога да намеря таблиците които трябва да кеширам. Пуснати ли са всички миграции?\n\n"
    end
  end


  def fix_id_to_s class_name_or_object
    self[class_name_or_object].collect do |o|
      oo = OpenStruct.new(o.marshal_dump)
      oo.id = oo.id.to_s
      oo
    end
  end

  def storage
    @cache
  end

  # returns the the key - aways string
  def get_key class_name_or_record
    case class_name_or_record
    when Class
      key = class_name_or_record.to_s
    when String
      key = class_name_or_record
    else
      key = class_name_or_record.class.to_s
    end
    key
  end

  def key? class_name_or_object
    key = get_key(class_name_or_object)
    self.storage.keys.include? key
  end
  
end
