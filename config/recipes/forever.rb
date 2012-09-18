namespace :forever do
  desc "Install forever"
  task :install, roles: :app do
    "#{sudo} npm install forever -g"
  end

  
  %w[start stop restart].each do |command|
    desc "#{command} forever"
    task command, roles: :web do
      run "#{sudo} NODE_ENV=production forever #{command} #{current_path}/kapiquajs/dst/app.js"
    end
  end

end