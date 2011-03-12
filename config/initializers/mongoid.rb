#File.open(::Rails.root.join('config/database.mongo.yml'), 'r') do |f|
#  @settings = YAML.load(f)[::Rails.env]
#end

Mongoid.configure do |config|
#  name = @settings["database"]
#  host = @settings["host"]
#  port = @settings["port"]
#
#  options = {:logger => "irb" == $0 ? Logger.new($stdout) : Rails.logger}
#  options = {}
#
#  config.master = Mongo::Connection.new(host, port, options).db(name)
#  config.slaves = [
#    #    Mongo::Connection.new(host, @settings["slave_one"]["port"], :slave_ok => true).db(name),
#    #    Mongo::Connection.new(host, @settings["slave_two"]["port"], :slave_ok => true).db(name)
#  ]
#  #  config.master = Mongo::Connection.new(host, port, logger => "irb" == $0 ?
#  #      Logger.new($stdout) : Rails.logger).db(name)
end

#Mongoid.add_language("bg")
#Mongoid.add_language("ru")

#Mongoid::config.add_language('bg')