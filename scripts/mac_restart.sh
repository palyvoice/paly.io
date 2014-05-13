cat $PALYIO_HOME_DIR$PALYIO_WORKING_DIR'tmp/pids/unicorn.pid' | xargs kill -QUIT
unicorn -c $PALYIO_HOME_DIR$PALYIO_WORKING_DIR'unicorn.rb' -E development -D
