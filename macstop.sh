cat tmp/pids/* | xargs kill -QUIT
nginx -s stop
mysql.server stop
