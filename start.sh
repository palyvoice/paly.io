source ~/.bashrc
bundle install
unicorn -c unicorn.rb -E development -D
