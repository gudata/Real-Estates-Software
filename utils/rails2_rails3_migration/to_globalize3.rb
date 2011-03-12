# Няма нужда от това.
class ActiveRecord::Migration
  @@translated = {
    "Team" => ["name","description"],
    "Status" => ["name"],
    "StandartChoice" => ["name"],
    "Sphere" => ["name"],
    "Sell" => ["description"],
    "RoomType" => ["name"],
    "Room" => ["description"],
    "Role" => ["name"],
    "RoadType" => ["name"],
    "Quarter" => ["name"],
    "PropertyType" => ["name"],
    "PropertyLocation" => ["name"],
    "PropertyFunction" => ["name"],
    "PropertyCategoryLocation" => ["name"],
    "ProjectStage" => ["name"],
    "Project" => ["name", "description", "aditional_description", "reference_point"],
    "PhoneType" => ["name"],
    "Office" => ["name", "description"],
    "OfferType" => ["name"],
    "Municipality" => ["name"],
    "Keyword" => ["name"],
    "InternetComunicatorType" => ["name"],
    "InfrastructureType" => ["name"],
    "HeatingType" => ["name"],
    "FenceType" => ["name"],
    "ExposureType" => ["name"],
    "District" => ["name", "description"],
    "Country" => ["name"],
    "ContactCategory" => ["name"],
    "Contact" => ["description"],
    "ConstructionType" => ["name"],
    "City" => ["name", "description"],
    "BuildingType" => ["name"],
    "Building" => ["description"],
    "ApartmentType" => ["name"],
  }
  
  @@translated.keys.each do |key, value|
    klass = key.constantize
    if !klass.respond_to?(:translates)
      puts "restoring translates method for #{klass}"
      klass.class_eval do
        def translates *args
          
        end
      end
    end

    plural_name = key.tableize
    singular_name = plural_name.singularize

    old_name =  "#{singular_name}_translations"
    new_name = "#{plural_name}_translations"
    puts "rename #{old_name} #{new_name}"
    rename_table old_name, new_name
  end
end