set :application, "kapiqua25"
set :deploy_to, "/Users/EdwardData/Sites/kpiqa25/kapiqua25/#{application}"
set :bin_folder, "#{current_path}/bin"
set :templates_path, "#{current_path}/config/recipes/templates"

namespace :nginx do
  
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
  


  desc "generate nginx setup"
  task :generate, roles: :app do
    erb = File.read(File.expand_path("#{templates_path}/nginx_unicorn_#{stage}.erb"))
    result = ERB.new(erb).result(binding)
    puts result
    # put result, '/tmp/nginx.conf'
  end

  desc "setup nginx setup"
  task :setup, roles: :app do
    generate
    run "#{sudo} mv /tmp/nginx.conf /usr/local/etc/nginx/nginx.conf"
  end
  before 'nginx:setup', 'nginx:stop'
  # after 'nginx:setup', 'nginx:start'


end