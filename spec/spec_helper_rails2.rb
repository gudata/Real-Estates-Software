require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However, 
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  
  # This file is copied to ~/spec when you run 'ruby script/generate rspec'
  # from the project root directory.
  ENV["RAILS_ENV"] ||= 'test'
#  require 'benchmark'
  require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
  require 'spec/autorun'
  require 'spec/rails'
  
  # тези бавят
  require 'machinist/active_record'
  require "machinist/mongoid"
end


Spork.each_run do
  # ако искаме бързина това трябва да е отвън
  require File.expand_path(File.dirname(__FILE__) + "/blueprints")

  ActiveRecord::Base.establish_connection # make sure that the db connection is ready.

  # This code will be run each time you run your specs.
  require File.expand_path(File.dirname(__FILE__) + "/helpers/ability_helper_methods")
  require File.expand_path(File.dirname(__FILE__) + "/helpers/sell_helper_methods")

  require File.dirname(__FILE__) + "/custom_matchers"

  # Uncomment the next line to use webrat's matchers
  #require 'webrat/integrations/rspec-rails'

  # Requires supporting files with custom matchers and macros, etc,
  # in ./support/ and its subdirectories.
  Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

  Spec::Runner.configure do |config|
    config.include(CustomMatchers)

    config.before(:all)    { Sham.reset(:before_all)  }
    config.before(:each)   { Sham.reset(:before_each) }


    # If you're not using ActiveRecord you should remove these
    # lines, delete config/database.yml and disable :active_record
    # in your config/boot.rb
    config.use_transactional_fixtures = true
    config.use_instantiated_fixtures  = false
    config.fixture_path = RAILS_ROOT + '/spec/fixtures/'


  end


end
