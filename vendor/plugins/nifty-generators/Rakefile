require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('nifty-generators', '0.3.0') do |p|
  p.project        = "niftygenerators"
  p.description    = "A collection of useful generator scripts for Rails."
  p.url            = "http://github.com/ghart/nifty-generators"
  p.author         = 'Greg Hart'
  p.email          = "ghart (at) cs1 (dot) com"
  p.ignore_pattern = ["script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
