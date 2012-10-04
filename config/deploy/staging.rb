
set :host , '192.168.101.50'
server "#{host}", :web, :app, :db, primary: true
set :user, 'soporte'
set :repository,  "ssh://#{user}@#{host}/home/#{user}/#{application}.git"
set :deploy_to, "/var/www/#{application}"


namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      sudo "/etc/init.d/unicorn_#{application} #{command}"
    end
  end
end
