cat $PALYIO_HOME_DIR$PALYIO_WORKING_DIR'tmp/pids/*' | xargs kill -QUIT
nginx -s stop
mysql.server stop
