namespace :forever do
  desc "Install forever"
  task :install, roles: :app do
    "#{sudo} npm install forever -g"
  end
  
  %w[start stop].each do |command|
    desc "#{command} forever"
    task command, roles: :web do
      run "#{sudo} /Library/WebServer/kapiqua25/current/deploy_configs/forever #{command}"
    end
  end
  
  desc "restart forever"
  task :restart,roles: :web do
    stop
    start
  end

end