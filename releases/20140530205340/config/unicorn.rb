root = "/home/deploy/apps/UCSDFoodCrumbs"
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"
 
# change the YOUR_APP_NAME to your application name
listen "/tmp/unicorn.UCSDFoodCrumbs.sock"
worker_processes 2
timeout 30
 
#before_exec do |server|
 # ENV['BUNDLE_GEMFILE'] = '/mnt/Hipstaweb-<%= RUBBER_ENV %>/current/Gemfile'
#end

before_exec do |_|
  ENV["BUNDLE_GEMFILE"] = File.join(root, 'Gemfile')
end
