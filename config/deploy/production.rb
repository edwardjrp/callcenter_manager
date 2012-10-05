set :host , '10.10.0.50'
server "#{host}", :web, :app, :db, primary: true
set :user, 'proteus'
set :repository,  "ssh://#{user}@#{host}/Users/#{user}/#{application}.git"
set :deploy_to, "/Library/WebServer/#{application}"
set :bin_folder, "#{current_path}/bin"
set :templates_path, "#{current_path}/config/recipes/templates"


namespace :deploy do
  desc "start unicorn server"
  task :start, roles: :app do
    sudo "launchctl load -w /Library/LaunchDaemons/unicorn.plist"
  end
  desc "stop unicorn server"
  task :stop, roles: :app do
    sudo "launchctl unload -w /Library/LaunchDaemons/unicorn.plist"
  end
  desc "restart unicorn server"
  task :restart, roles: :app do
    stop
    start
  end

  task :setup_config, roles: :app do
   # sudo "ln -nfs #{current_path}/deploy_configs/kapiqua.conf /usr/local/etc/nginx/nginx.conf"
   sudo "ln -nfs #{current_path}/deploy_configs/kapiqua_unicorn_init.sh /etc/init.d/unicorn_#{application}"
   sudo "chmod +x #{current_path}/deploy_configs/kapiqua_unicorn_init.sh"
   run "mkdir -p #{shared_path}/config"
   run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  before "deploy:restart", "deploy:setup_config"
end


namespace :unicorn do
  desc "generate unicorn setup"
  task :generate, roles: :app do
    erb = File.read(File.expand_path("#{templates_path}/nginx_unicorn_#{stage}.erb"))
    result = ERB.new(erb).result(binding)
    put result, '/tmp/nginx.conf'
  end

  desc "setup unicorn setup"
  task :setup, roles: :app do
    generate
    run "#{sudo} mv /tmp/nginx.conf /usr/local/etc/nginx/"
  end
end