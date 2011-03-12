module CanCan
#  class ResourceAuthorization
#    def model_name
#      return @options[:name] if @options.key? :name
#      if @options.key? :resource
#        @options[:resource].to_s.tableize.singularize
#      else
#        params[:controller].sub("Controller", "").underscore.split('/').last.singularize
#      end
#    end
#
#  end
end