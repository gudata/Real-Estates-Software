app_path = "/home/mongrel/re"
shared_path = "#{app_path}/shared"
working_directory "#{app_path}/current"

# preload_app=true

# See http://unicorn.bogomips.org/Unicorn/Configurator.html for complete
# documentation.

worker_processes 2



# listen on both a Unix domain socket and a TCP port,
# we use a shorter backlog for quicker failover when busy
listen "/tmp/re_production.socket", :backlog => 64

# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 60

# feel free to point this anywhere accessible on the filesystem
user 'mongrel', 'mongrel'

pid "#{shared_path}/pids/unicorn.pid"
stderr_path "#{shared_path}/log/unicorn.stderr.log"
stdout_path "#{shared_path}/log/unicorn.stdout.log"
