sudo /etc/init.d/mysql start
cd $PALYIO_HOME_DIR$PALYIO_WORKING_DIR
bundle install
unicorn -c unicorn.rb -E development -D
cd -
sudo /etc/init.d/nginx start

