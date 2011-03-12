# This file is used by Rack-based servers to start the application.
# http://therailworld.com/posts/28-Using-Rack-Middleware-in-Rails3
# use Rack::Codehighlighter, :coderay, :element => "pre", :pattern => /\A:::(\w+)\s*\n/

require ::File.expand_path('../config/environment',  __FILE__)

run Re::Application
