set :stages, %w(production staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'
require "bundler/capistrano"
require 'sidekiq/capistrano'

load "config/recipes/nginx"
load "config/recipes/forever"
load "config/recipes/nodejs"
load 'deploy/assets'

# server '192.168.101.50', :web, :app, :db, primary: true
# set :user, 'soporte'
set :application, "kapiqua25"
# set :repository,  "ssh://soporte@127.0.0.1/home/soporte/#{application}.git"

# set :deploy_to, "/var/www/#{application}"
# set :bin_folder, "#{current_path}/bin"

set :deploy_via, :remote_cache
set :scm, 'git'
set :branch, 'master'
set :scm_verbose, true
# set :use_sudo, false
set :deploy_via, :remote_cache

default_run_options[:pty] = true


after "deploy", "deploy:cleanup"


namespace :deploy do

  task :coffee_compile, roles: :app do
    puts "Compiling coffee files."
    run "mkdir -p #{shared_path}/node_modules"
    run("ln -nfs #{shared_path}/node_modules #{current_path}/kapiquajs/node_modules")
    run "cd #{current_path}/kapiquajs && #{sudo} npm link coffee-script"
    run "cd #{current_path}/kapiquajs && #{sudo} npm install"
    run "coffee #{current_path}/kapiquajs/build.coffee"
    puts "done."
  end
  before "forever:restart", "deploy:coffee_compile"
  after "deploy:restart", "forever:restart" 
  # after "deploy:restart", "deploy:coffee_compile"
  
  task :db_config, roles: :app do
    run "mkdir -p #{shared_path}/config"
    run("ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml")
    # put File.read("config/database.#{stage}.yml"), "#{shared_path}/config/database.yml"
  end
  after "deploy:finalize_update", "deploy:db_config"
end