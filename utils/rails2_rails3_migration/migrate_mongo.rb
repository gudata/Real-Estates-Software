require 'mongo'

# Stop writing to your database.
# Then, for each collection:
# Specify the DB and COLLECTION you want to convert.
# Will insert all modified documents into a new collection
# called 'new_' + old_collection_name.
# Then you can delete the old collection and rename the new one
# once you've verified that the new collection is correct.

DB = "re_production"

COLLECTIONS = %w(buy_statuses buys search_criterias sell_documents terms)

def convert_ids(obj, parent_key)

  if obj.is_a?(String) && obj =~ /^[a-f0-9]{24}$/
    BSON::ObjectId(obj)
  elsif obj.is_a?(Array)
    obj.map do |v|
      convert_ids(v, parent_key)
    end
  elsif obj.is_a?(Hash)
    obj.each do |key, v|
      obj[key] = convert_ids(v, key)
    end
  else
    if parent_key.nil? or parent_key =~ /^[a-z_A-Z0-9]+?_id$/
      obj.nil? ? obj : obj.to_i
    else
      return obj
    end
  end
end

def convert_collection collection
  original_collection = @db[collection]
  new_collection = @db['new_' + collection]
  backup_collection = @db['' + collection + '_backup']

  backup_collection.drop
  new_collection.drop
  
  original_collection.find({}, :timeout => false, :sort => "_id") do |c|
    c.each do |doc|
      new_doc = convert_ids(doc, nil)
      new_collection.insert(new_doc, :safe => true)
    end
  end

  begin
    original_collection.rename("#{collection}_backup")
    new_collection.rename("#{collection}")
  rescue
    puts "collection #{collection} cant be renamed"
  end
end

@con = Mongo::Connection.new
@db = @con[DB]

COLLECTIONS.each do |collection|
  convert_collection collection
end