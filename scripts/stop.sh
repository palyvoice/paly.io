cd $PALYIO_HOME_DIR$PALYIO_WORKING_DIR
cat tmp/pids/unicorn.pid | xargs kill -QUIT
rm tmp/pids/unicorn.pid
rm tmp/sockets/unicorn.sock
cd -
