set :host , '192.168.101.50'
server "#{host}", :web, :app, :db, primary: true
set :user, 'soporte'
set :repository,  "ssh://#{user}@#{host}/home/#{user}/#{application}.git"
set :deploy_to, "/var/www/#{application}"
set :bin_folder, "#{current_path}/bin"


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
  end
  before "deploy:restart", "deploy:setup_config"
end
