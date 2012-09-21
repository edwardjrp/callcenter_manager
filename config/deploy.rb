require "bundler/capistrano"

load "config/recipes/nginx"
load "config/recipes/forever"
load "config/recipes/nodejs"
load 'deploy/assets'

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


namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      sudo "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  task :setup_config, roles: :app do
   sudo "ln -nfs #{current_path}/deploy_configs/kapiqua.conf /etc/nginx/sites-enabled/#{application}"
   sudo "ln -nfs #{current_path}/deploy_configs/kapiqua_unicorn_init.sh /etc/init.d/unicorn_#{application}"
   sudo "chmod +x #{current_path}/deploy_configs/kapiqua_unicorn_init.sh"
   run "mkdir -p #{shared_path}/config"
   put File.read("config/database.production.yml"), "#{shared_path}/config/database.yml"
  end
  before "deploy:restart", "deploy:setup_config"

  task :coffee_compile, roles: :app do
    puts "Compiling coffee files."
    run "cd #{current_path}/kapiquajs && #{sudo} npm link coffee-script"
    run "cd #{current_path}/kapiquajs && #{sudo} npm install"
    run "/usr/bin/coffee #{current_path}/kapiquajs/build.coffee"
    puts "done."
  end
  # before "deploy:symlink_config", "deploy:coffee_compile" 

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