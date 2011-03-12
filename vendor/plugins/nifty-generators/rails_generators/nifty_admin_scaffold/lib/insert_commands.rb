Rails::Generator::Commands::Create.class_eval do
  def route_namespaced_resources(namespace, *resources)  
    resource_list = resources.map { |r| r.to_sym.inspect }.join(', ')
    sentinel = 'ActionController::Routing::Routes.draw do |map|'
    
    logger.route "#{namespace}.resources #{resource_list}"
    unless options[:pretend]
      gsub_file 'config/routes.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
        "#{match}\n  map.namespace(:#{namespace}) do |#{namespace}|\n    #{namespace}.resources #{resource_list}\n  end\n"
      end
    end
  end
end

Rails::Generator::Commands::Destroy.class_eval do
  def route_namespaced_resources(namespace, *resources)
    resource_list = resources.map { |r| r.to_sym.inspect }.join(', ')
    look_for = "\n    #{namespace}.resources #{resource_list}\n"
    logger.route "#{namespace}.resources #{resource_list}"
    unless options[:pretend]
      gsub_file 'config/routes.rb', /(#{look_for})/mi, ''
    end
  end
end

Rails::Generator::Commands::List.class_eval do
  def route_namespaced_resources(namespace, *resources)
    resource_list = resources.map { |r| r.to_sym.inspect }.join(', ')
    logger.route "#{namespace}.resources #{resource_list}"
  end
end
