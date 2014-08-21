=begin
working_directory "/Users/EdwardData/Sites/kpiqa25/current"
pid "/Users/EdwardData/Sites/kpiqa25/current/tmp/pids/unicorn.pid"
stderr_path "/Users/EdwardData/Sites/kpiqa25/current/log/unicorn.log"
stdout_path "/Users/EdwardData/Sites/kpiqa25/current/log/unicorn.log"

listen "/tmp/unicorn.kapiqua.sock"
worker_processes 2
timeout 30
=end
root = "/vagrant"
app_name = "kapiqua"
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

listen "/tmp/unicorn.#{app_name}.sock"
worker_processes 2
timeout 30
preload_app true
