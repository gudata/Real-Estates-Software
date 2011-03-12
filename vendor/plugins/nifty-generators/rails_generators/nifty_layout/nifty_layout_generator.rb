require File.expand_path(File.dirname(__FILE__) + "/lib/insert_commands.rb")
class NiftyLayoutGenerator < Rails::Generator::Base
  def initialize(runtime_args, runtime_options = {})
    super
    @name = @args.first || 'application'
  end
  
  def manifest
    record do |m|
      if options[:compass]
        m.directory     'app/stylesheets/partials'
        m.file          "stylesheet.sass",  "app/stylesheets/partials/_#{file_name}.sass"
        m.insert_after  "app/stylesheets/screen.sass", "@import blueprint/modules/scaffolding.sass", "\n@import partials/#{file_name}.sass"
        m.replace       "app/stylesheets/screen.sass", "// +blueprint", "+blueprint"
      elsif options[:haml]
        m.directory 'public/stylesheets/sass'
        m.file      "stylesheet.sass",  "public/stylesheets/sass/#{file_name}.sass"
      else
        m.directory 'public/stylesheets'
        m.file      "stylesheet.css",  "public/stylesheets/#{file_name}.css"
      end
      
      m.directory 'app/views/layouts'
      if options[:haml]
        m.template "layout.html.haml", "app/views/layouts/#{file_name}.html.haml"
      else
        m.template "layout.html.erb", "app/views/layouts/#{file_name}.html.erb"
      end
      
      m.directory 'app/helpers'
      m.file "helper.rb", "app/helpers/layout_helper.rb"
    end
  end
  
  def file_name
    @name.underscore
  end

  protected

    def add_options!(opt)
      opt.separator ''
      opt.separator 'Options:'
      opt.on("--haml", "Generate HAML for view, and SASS for stylesheet.") { |v| options[:haml] = v }
      opt.on("--compass", "Use Compass for stylesheets.") { |v| options[:compass] = v }
    end

    def banner
      <<-EOS
Creates generic layout, stylesheet, and helper files.

USAGE: #{$0} #{spec.name} [layout_name]
EOS
    end
end
