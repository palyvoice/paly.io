source ~/.bashrc
cd $PALYIO_HOME_DIR$PALYIO_WORKING_DIR
unicorn -c unicorn.rb -E development -D
cd -
