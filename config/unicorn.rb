#working_directory "/Library/WebServer/kapiqua25/current"
working_directory "/Users/EdwardData/Sites/kpiqa25/current"
pid "/Users/EdwardData/Sites/kpiqa25/current/tmp/pids/unicorn.pid"
stderr_path "/Users/EdwardData/Sites/kpiqa25/current/log/unicorn.log"
stdout_path "/Users/EdwardData/Sites/kpiqa25/current/log/unicorn.log"

listen "/tmp/unicorn.kapiqua25.sock"

  worker_processes 20

timeout 30