mysql.server start
nginx
unicorn -c $PALYIO_HOME_DIR$PALYIO_WORKING_DIR'unicorn.rb' -E development -D
