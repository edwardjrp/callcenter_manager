set :host , '10.0.0.198'
server "#{host}", :web, :app, :db, primary: true
#set :user, 'proteus'
set :user, 'Edward'
set :repository,  "ssh://#{user}@#{host}/Users/#{user}/Sites/kpiqa25/#{application}.git"
set :deploy_to, "/Users/EdwardData/Sites/kpiqa25/deployment/staging/#{application}"
# set :bin_folder, "#{current_path}/bin"
set :templates_path, "config/recipes/templates"


namespace :deploy do
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse staging/master`
      puts "WARNING: HEAD is not the same as staging/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"

  # task :setup_config, roles: :app do
   # sudo "ln -nfs #{current_path}/deploy_configs/kapiqua.conf /usr/local/etc/nginx/nginx.conf"
  #  sudo "ln -nfs #{current_path}/deploy_configs/kapiqua_unicorn_init.sh /etc/init.d/unicorn_#{application}"
  #  sudo "chmod +x #{current_path}/deploy_configs/kapiqua_unicorn_init.sh"
  #  run "mkdir -p #{shared_path}/config"
  #  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  # end
  # before "deploy:restart", "deploy:setup_config"
end


namespace :unicorn do
  desc "generate unicorn setup"
  task :setup, roles: :app do
    erb_plist = File.read(File.expand_path("#{templates_path}/unicorn_start_osx.erb"))
    result_plist = ERB.new(erb_plist).result(binding)
    puts result_plist
    # put result_plist, '/tmp/unicorn_start_osx.plist'
    # run "#{sudo} mv /tmp/unicorn_start_osx.conf /Library/LaunchDaemons/unicorn.plist"
  end

  desc "generate unicorn config"
  task :config, roles: :app do
    erb_config = File.read(File.expand_path("#{templates_path}/unicorn_config.erb"))
    result_config = ERB.new(erb_config).result(binding)
    puts result_config
    # put result_config, '/tmp/unicorn_config.conf'
    # run "#{sudo} mv /tmp/unicorn_config.conf #{current_path}/config/unicorn.rb"
  end


end