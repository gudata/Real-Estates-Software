# Deploy with Capistrano
gem 'capistrano'
gem 'capistrano-ext'

gem 'rake', '~> 0.8.7'

source 'http://rubygems.org'

gem 'mysql2', "~> 0.2.6"
gem 'ya2yaml'

gem 'rails', '3.0.7'
gem 'rack', '1.2.1'

gem 'awesome_print', :require => 'ap'
gem 'formtastic', '~> 1.1.0'
#gem 'formtastic', '~> 1.2.0'

gem 'ya2yaml'
gem 'rmagick'
gem 'cancan', '1.3.4'

source 'http://gemcutter.org'
#gem 'will_paginate', :branch => "rails3" '>= 3.0.pre2'
gem 'will_paginate', :git => 'https://github.com/dbackeus/will_paginate.git'

source 'http://gems.github.com'
gem "meta_search" #, '>=0.9.10'  # Last officially released gem
#gem 'be9-awesome_nested_set'

gem 'geokit', '>= 1.5.0'

gem "globalize3"
gem "haml"

#gem 'mongoid', git: 'git://github.com/durran/mongoid.git', branch: 'prerelease'
gem "mongoid", "2.0.0.beta.20", :require => 'mongoid'
gem "bson_ext"

gem 'mongoid_i18n', :require => 'mongoid/i18n'
gem 'paperclip', '>= 2.3.10', :require => 'paperclip'
gem 'carrierwave'
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'


gem 'authlogic', ">=2.1.6"
gem 'omniauth' #, '0.1.6'

group :development do
  # patch for netbeans debuger
  #gem 'newrelic_rpm'
  gem 'mongrel'
  gem "ruby-debug"
  gem "annotate"
  gem 'itslog'

  #  gem 'metric_fu', :require => 'metric_fu'
end

group :test do
  #  gem 'rspec', '>= 1.2.0'
  
  # database cleaner
  # http://blog.tristanmedia.com/2010/07/rails-3-rspec-and-database-cleaner/
  gem 'faker'
  gem "rspec-rails", ">= 2.0.0.beta.20"
  #   config.gem 'rspec-rails', :version => '>= 1.3.2', :lib => false unless File.directory?(File.join(Rails.root, 'vendor/plugins/rspec-rails'))
  gem 'machinist_mongo'
  # Bundle the extra gems:
  #gem 'machinist_mongo'
  #  gem 'webrat'
end
