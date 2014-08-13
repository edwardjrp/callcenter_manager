#!/bin/sh
set -e
# Example init script, this can be used with nginx, too,
# since nginx and unicorn accept the same signals

# Feel free to change any of the following variables for your app:
TIMEOUT=${TIMEOUT-60}
#APP_ROOT=/var/www/kapiqua25/current
APP_ROOT=/Users/EdwardData/Sites/kpiqa25/current
PID=$APP_ROOT/tmp/pids/unicorn.pid
#CMD="$APP_ROOT/bin/unicorn -D -c $APP_ROOT/deploy_configs/kapiqua_unicorn.rb -E production"
CMD="$APP_ROOT/bin/unicorn -D -c $APP_ROOT/deploy_configs/kapiqua_unicorn.rb -E development"
action="$1"
set -u

old_pid="$PID.oldbin"

cd $APP_ROOT || exit 1

sig () {
	test -s "$PID" && kill -$1 `cat $PID`
}

oldsig () {
	test -s $old_pid && kill -$1 `cat $old_pid`
}

case $action in
start)
	sig 0 && echo >&2 "Already running" && exit 0
	su -c "$CMD" - soporte
	;;
stop)
	sig QUIT && exit 0
	echo >&2 "Not running"
	;;
force-stop)
	sig TERM && exit 0
	echo >&2 "Not running"
	;;
*)
	echo >&2 "Usage: $0 <start|stop>"
	exit 1
	;;
esac