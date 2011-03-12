module Mongoid::ActiverecordPatch

  def fix_id_types
    #    puts "fixing"
    self.attributes.each do |key, value|
      if !value.blank? and key =~ /^[a-z_A-Z0-9]+?_id$/ and value.class !=  BSON::ObjectId
        Rails::logger.debug "fixing ids: #{key}= #{value}"
        self.send("#{key}=", value.to_i)
      end
    end
  end
end