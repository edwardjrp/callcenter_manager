server '10.10.0.50', :web, :app, :db, primary: true
set :user, 'proteus'
set :repository,  "ssh://#{user}@#{server}/Users/#{user}/#{application}.git"
set :deploy_to, "/Library/WebServer/#{application}"


namespace :deploy do
  desc "start unicorn server"
  task :start, roles: :app, except: {no_release} do
    sudo "launchctl load -w /Library/LaunchDaemons/unicorn.plist"
  end
  desc "stop unicorn server"
  task :stop, roles: :app, except: {no_release} do
    sudo "launchctl unload -w /Library/LaunchDaemons/unicorn.plist"
  end
  desc "restart unicorn server"
  task :restart, roles: :app, except: {no_release} do
    stop
    start
  end
end



