require "bundler/capistrano"


server '192.168.101.50', :web, :app, :db, primary: true
set :user, 'soporte'
set :application, "kapiqua25"
set :repository,  "ssh://soporte@192.168.101.50/home/soporte/#{application}.git"

set :deploy_to, "/var/www/#{application}"

set :deploy_via, :remote_cache
set :scm, 'git'
set :branch, 'master'
set :scm_verbose, true
set :use_sudo, false
set :deploy_via, :remote_cache

default_run_options[:pty] = true


after "deploy", "deploy:cleanup"

# after "deploy:update_code", :bundle_install 
# desc "install the necessary prerequisites" 
# task :bundle_install, :roles => :app do
#   run "cd #{release_path} && bundle install" 
# end


namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  # task :setup_config, roles: :app do
  #   # sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
  #   # sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.production.yml"), "#{shared_path}/config/database.yml"
  #   # puts "Now edit the config files in #{shared_path}."
  # end
  # after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end