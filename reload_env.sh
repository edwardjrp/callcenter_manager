#!/bin/bash
RAILS_ENV=production bin/rake assets:precompile
sh /etc/init.d/unicorn stop
sleep 2
sh /etc/init.d/unicorn start
sudo service nginx restart
