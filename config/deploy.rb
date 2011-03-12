#require 'mongrel_cluster/recipes'
set :stages, %w(staging production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

# TODO: Use those recipes for unicorn deployment http://github.com/daemon/capistrano-recipes
#set :deploy_to, "/home/mongrel/re_staging"

set(:mongrel_conf) { "#{current_path}/config/mongrel_cluster.yml" }


set :scm_username, "gudata"
set :application, "re"
set :repository,  "git@github.com:gudata/Real-Estates-Software.git"
set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :scm_verbose, true
set :keep_releases, 3

set :ssh_options, { :forward_agent => true }
#ssh_options[:forward_agent] = true
#ssh_options[:paranoid] = false

role :web, "sarah.gudasoft.com"                          # Your HTTP server, Apache/etc
role :app, "sarah.gudasoft.com"                          # This may be the same as your `Web` server
role :db,  "sarah.gudasoft.com", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

set :user, "mongrel"
set :runner, "mongrel"
set :branch, "master"

#set :deploy_via, :copy
set :deploy_via, :remote_cache
#set :git_shallow_clone, 0     # only copy the most recent, not the entire repository (default:1)

ssh_options[:compression] = "none" 
ssh_options[:keys] = %w(/home/guda/.ssh/id_rsa)
ssh_options[:port] = 22



#load "#{staging}"
load "#{production}"









def preserve_folder(folder)
  #       if rails_env == 'production' || rails_env == 'qa'

  cmd = <<-CMD
                 rm -rf #{deploy_to}/current/public/#{folder};

                 if [ ! -d #{deploy_to}/shared/images/#{folder} ] ; then
                         mkdir -p #{deploy_to}/shared/images/#{folder} ;
                         chown #{user}:#{wgroup} #{deploy_to}/shared/images/#{folder} ;
                         chmod g+ws #{deploy_to}/shared/images/#{folder} ;
                 fi ;
                 if [ ! -L #{deploy_to}/current/public/#{folder} -a -d #{deploy_to}/current/public/#{folder} ] ; then
                         echo "public/#{folder}/ is a directory!" ;
                         exit 1 ;
                 fi ;
                 if [ ! -L #{deploy_to}/current/public/#{folder} ] ; then
                         ln -nsf #{deploy_to}/shared/images/#{folder} \
                         #{deploy_to}/current/public/#{folder} ;
                 fi ;
  CMD
  return cmd
end


#set :wgroup, "mongrel"
#desc "save the image repository between the deploys. The images are kept in /shared/ and after this task a sym link is created under current/public for them."
#task :images do
#  puts "Save the restore the images that are on the server /shared ..."
#  #        run 'ls'
#  run preserve_folder("agent")
#  run preserve_folder("category")
#  run preserve_folder("company")
#  run preserve_folder("group")
#  run preserve_folder("source_thumbs")
#  run preserve_folder("source_favico")
#end


  
#after "deploy:update",  "deploy:clean_cache"
namespace :deploy do

  namespace :web do
    task :disable, :roles => :web do
      require 'erb'
      on_rollback { delete "#{shared_path}/system/maintenance.html" }

      reason = ENV['REASON']
      deadline = ENV['UNTIL']
      template = File.read('app/views/layouts/maintenance.erb')
      page = ERB.new(template).result(binding)

      put page, "#{shared_path}/system/maintenance.html", :mode => 0644

      put page, "#{shared_path}/system/maintenance.html",
        :mode => 0644
    end
  end

  desc "Asks the user for the tag to deploy"
  task :before_update_code do
    set :branch, Proc.new { CLI.ui.ask "Branch to deploy or just hit enter to deploy master"}
    set :branch, branch.chomp
    if !branch.nil? && branch == "current"
      set :branch, $1.to_sym if `git branch` =~ /\* (\S+)\s/m
    elsif !branch.nil? and !branch.empty?
      set :branch, branch.to_sym
    else   # add more as needed
      set :branch, "master".to_sym
    end
    puts "working on branch #{branch} #{branch.class}"
  end


  desc "Cleanling the cache"
  task :clean_cache do
    run "rm #{release_path}/public/stylesheets/cached_css.css"
    run "rm #{release_path}/public/javascripts/cached_javascript.js"
  end
  
  
  set :unicorn_binary, "/usr/bin/unicorn"
  set :unicorn_config, "#{current_path}/unicorn.ru"
  set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"
  # set :rails_env, :production this is set in multistage deploy
  
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && #{try_sudo} #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} kill `cat #{unicorn_pid}`"
  end
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} kill -s QUIT `cat #{unicorn_pid}`"
  end
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} kill -s USR2 `cat #{unicorn_pid}`"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end

  task :after_update_code, :roles => [:web] do
    desc "Copying the right mongrel cluster config for the current stage environment."
    run "cp -f #{release_path}/config/mongrel_cluster_#{stage}.yml #{release_path}/config/mongrel_cluster.yml"
    desc "Copying the right unicorn config for the current stage environment."
    run "cp -f #{release_path}/config/unicorn_#{stage}.ru #{release_path}/unicorn.ru"
  end

  # in RAILS_ROOT/config/deploy.rb:
  after 'deploy:update_code', 'deploy:symlink_db'
  desc "Symlinks the database.yml"
  task :symlink_db, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end

end