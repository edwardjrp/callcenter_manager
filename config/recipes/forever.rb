namespace :forever do
  desc "Install forever"
  task :install, roles: :app do
    "#{sudo} npm install forever -g"
  end


  desc "start forever"
  task :start, roles: :web, on_error: :continue do
    run "#{sudo} /bin/bash -c '#{current_path}/deploy_configs/forever start'"
  end



  desc "stop forever"
  task :stop, roles: :web, on_error: :continue do
    run "#{sudo} /bin/bash -c '#{current_path}/deploy_configs/forever stopall'"
  end


  desc "restart forever"
  task :restart,roles: :web, on_error: :continue do
    stop
    start
  end

end