module SearchHelper
  def params_to_i attributes, params
    attributes.each do |key|
      self.instance_variable_set(:"@#{key}", params[key])
      # single valies
      if key.to_s =~ /^[a-z_A-Z0-9]+?_id$/
        self.send("#{key}=", params[key].to_i) unless params[key].blank?
        # array values
      elsif key.to_s =~ /^[a-z_A-Z0-9]+?_ids$/
        value = params[key]
        unless value.blank?
          value = value.collect do |element|
            element.to_i unless element.blank?
          end.compact
          self.send("#{key}=", value) unless params[key].blank?
        end
      end
    end
  end
end
