namespace :nginx do
  namespace :linux do
    desc "Install latest stable release of nginx"
    task :install, roles: :web do
      run "#{sudo} add-apt-repository ppa:nginx/stable"
      run "#{sudo} apt-get -y update"
      run "#{sudo} apt-get -y install nginx"
    end
    # after "deploy:install", "nginx:install"
    
    %w[start stop restart].each do |command|
      desc "#{command} nginx"
      task command, roles: :web do
        run "#{sudo} service nginx #{command}"
      end
    end
  end
  namespace :osx do
    desc "Install latest stable release of nginx"
    task :install, roles: :web do
      run "#{sudo} brew install nginx"
    end
    # after "deploy:install", "nginx:install"
      
    desc "start nginx"
    task :start, roles: :web do
      run "#{sudo} launchctl load -w /Library/LaunchDaemons/homebrew.mxcl.nginx.plist "
    end

    desc "stop nginx"
    task :stop, roles: :web do
      run "#{sudo} launchctl unload -w /Library/LaunchDaemons/homebrew.mxcl.nginx.plist "
    end
    
  end
end