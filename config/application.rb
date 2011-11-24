require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)


module Re

  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    config.plugins = [ :exception_notification, :ssl_requirement, :all, :validation_reflection ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"
    
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone. Run "rake -D time" for a list of tasks for finding time zone names.
    config.time_zone = 'UTC'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]
    #  config.i18n.load_path += Dir[File.join(RAILS_ROOT, 'config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.default_locale = :bg
    config.i18n.locale = :bg

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password, :password_confirmation]



    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Add additional load paths for your own custom dirs
    config.autoload_paths += [
      config.root.join("app/models/mongoid").to_s,
      config.root.join("app/models/observers").to_s,
      config.root.join("app/controllers/admin/nomenclature").to_s,
      config.root.join("app/models/search_forms").to_s,
      config.root.join("app/models/nomenclature").to_s,
    ]

    #    config.reload_plugins = true

=begin
      за тестване ти трябва rspec
      config.gem "machinist_mongo"
=end
    
    # Only load the plugins named here, in the order given (default is alphabetical). :all can be used as a placeholder for all plugins not explicitly named config.plugins = [
    # :exception_notification, :ssl_requirement, :all ]

    # Skip frameworks you're not going to use. To use Rails without a database, you must remove the Active Record framework. config.frameworks -= [ :active_record, :active_resource,
    # :action_mailer ]

    # Activate observers that should always be running
    config.active_record.observers = [:offer_observer, :cache_observer]

    config.action_view.javascript_expansions[:defaults] = [
      "jquery-1.4.2.min",
      "jquery-ui-1.8.4.custom.min",
      "ui/i18n/jquery.ui.datepicker-bg.js",
      "ui/i18n/jquery.ui.datepicker-ru.js",
      "ui/i18n/jquery.ui.datepicker-sv.js",
      "ui/i18n/jquery.ui.datepicker-en.js",
      "rails",
      'calendar',
      'nested_attributes',
      "picbox/js/picbox.js",
      "jquery.tipsy",
      "jquery.cookie",
      "jquery.hints",
      "nyroModal/query.nyroModal-1.6.2.min",
      "modernizr",
      "jquery.json-2.2.min", # http://code.google.com/p/jquery-json/
      "application"
    ]

    config.action_view.javascript_expansions[:defaults] << "jquery.dump" if ::Rails.env == "development"

    # # MongoMapper.connection = Mongo::Connection.new('hostname') # MongoMapper.database = 'mydatabasename'
    #  Rotate logs
    # Add this to the Rails::Initializer.run block in environment.rb to keep 50 old logfiles of 1MB each: config.logger = Logger.new("#{RAILS_ROOT}/log/#{ENV['RAILS_ENV']}.log", 50, 1048576)
    config.logger = Logger.new(config.paths.log.first, 2, 5048576)

    # Make Active Record use UTC-base instead of local time
    config.active_record.default_timezone = :utc
    
    # http://www.akitaonrails.com/2008/5/25/rolling-with-rails-2-1-the-first-full-tutorial-part-1
    config.time_zone = 'UTC'
    

  end

  # http://github.com/josevalim/rails-footnotes
  if defined?(Footnotes)
    puts "ИЗПОЛЗВАНЕ НА Footnotes - пусни ме с SPEED=1 "
    Footnotes::Filter.prefix = 'netbeans://open?url=file://%s&amp;line=%d&amp;column=%d'
  end

  #require 'mongo_mapper/nested_attributes'
  require 'patch/active_record.rb'
  #require 'patch/hash.rb'
  require 'array.rb'
  require 'object.rb'
  require 'string.rb'

  ######## махнато с search logic-a
  #  module ActiveRecord
  #    class Base
  #      class << self; include SearchLogic::NoJoins; end
  #    end
  #  end
end