# make a mnogo filed from static to translated
# The forgotten buystatuses

require 'mongo'

#DB = "re_production"
DB = "re_development"

@con = Mongo::Connection.new
@db = @con[DB]


original_collection = @db["buy_statuses"]

original_collection.find({}, :timeout => false, :sort => "_id") do |documents|
  documents.each do |buy_status|
    if buy_status["name"].class == String
      old = buy_status["name"]
      buy_status["name"] = {}
      buy_status["name"]["bg"] = old
    end

    original_collection.save(buy_status)
  end
end










# make a mnogo filed from static to translated

require 'mongo'

#DB = "re_production"
DB = "re_development"

@con = Mongo::Connection.new
@db = @con[DB]


original_collection = @db["sell_documents"]

original_collection.find({}, :timeout => false, :sort => "_id") do |documents|
  documents.each do |sell_document|
    if sell_document["description"].class == String
      old = sell_document["description"]
      sell_document["description"] = {}
      sell_document["description"]["bg"] = old
    end

    if sell_document["address_document"] and sell_document["address_document"]["description"].class == String
      old = sell_document["address_document"]["description"]
      sell_document["address_document"]["description"] = {}
      sell_document["address_document"]["description"]["bg"] = old
    end

    if !sell_document["terms"].blank? and sell_document["terms"].class == Array
      puts sell_document["_id"]
      sell_document["terms"] = sell_document["terms"].collect do |term|
        if term["name"] and term["name"].class == String
          old = term["name"]
          term["name"] = {}
          term["name"]["bg"] = old
        end
        term
      end
    end
    
    original_collection.save(sell_document)
  end
end








# make a mnogo filed from static to translated

require 'mongo'

DB = "re_development"
DB = "re_production"

@con = Mongo::Connection.new
@db = @con[DB]


original_collection = @db["buys"]

original_collection.find({}, :timeout => false, :sort => "_id") do |documents|
  documents.each do |buy_document|
    if buy_document["description"].class == String
      old = buy_document["description"]
      buy_document["description"] = {}
      buy_document["description"]["bg"] = old
    end
    if buy_document["name"].class == String
      old = buy_document["name"]
      buy_document["name"] = {}
      buy_document["name"]["bg"] = old
    end

    if !buy_document["address_documents"].blank? and buy_document["address_documents"].class == Array
      buy_document["address_documents"] = buy_document["address_documents"].collect do |address_document|
        if address_document and address_document["description"].class == String
          old = address_document["description"]
          address_document["description"] = {}
          address_document["description"]["bg"] = old
        end
        address_document
      end
    end

    if !buy_document["search_criterias"].blank? and buy_document["search_criterias"].class == Array
      buy_document["search_criterias"] = buy_document["search_criterias"].collect do |search_criteria|
        if !search_criteria["terms"].blank? and search_criteria["terms"].class == Array
          puts search_criteria["_id"]
          search_criteria["terms"] = search_criteria["terms"].collect do |term|
            if term["name"] and term["name"].class == String
              old = term["name"]
              term["name"] = {}
              term["name"]["bg"] = old
            end
            term
          end
        end
        search_criteria
      end # collect search criterias
    end
    original_collection.save(buy_document)
  end
end


