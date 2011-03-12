namespace :translate do
  desc "Translate a from controller/action"


  task :form, :file_path, :needs => :environment do |t, args|
    require 'ftools'
    args.with_defaults(:file_path => nil)
    if args.file_path.nil? 
      puts <<-HELP
      Usage:
        rake translate:form[app/views/admin/projects/_form.html.erb] scope=\":admin, :project\"

The original file will be copied into /tmp

      HELP
    end
    
    file_path = File.join(RAILS_ROOT, args.file_path)
    scope = ENV["scope"] || ":replace_me"
    puts "Working on #{file_path}"
    puts "The scope for the translations will be #{scope}"
    
    text = []
    translated = []
    keys = []
    backup_file_path = File.join("/tmp", File.basename(file_path)) + "#{rand(5555)}.orig"
    File.copy(file_path, backup_file_path, true) unless File.exists?(backup_file_path)
    File.open(file_path) do |f|
      while line = f.gets
        text << line.chomp
      end
    end
    

    text.each do |line|
      line.chomp!
      line =~ /f.label :([^\s]+?) %>/
      name = $1
      keys << name
      line.sub!(/f.label :([^\s]+?) %>/, "f.label :#{name}, t(\"#{name}\", :scope => [#{scope}]) %>")

      line.sub!(/do \|f\| %>/, "do |f| %>\n<fieldset>\n<ul>\n")
      line.gsub!(/<% end %>/, "\n</ul>\n</fieldset>\n<% end %>")
      line.gsub!(/<p>(.*?)<\/p>/, "<li>\\1</li>")
      line.gsub!(/<p>/, "<li>")
      line.gsub!(/<\/p>/, "</li>")

      line.gsub!(/<br\s*?\/>/, "")

      translated << line
    end

    File.open(file_path, "w+") do |f|
      f.print translated.join("\n")
    end

    puts "The file\n"
    puts translated

    puts "For the yaml file:\n"
    puts keys.compact.join(":\n")

  end
end