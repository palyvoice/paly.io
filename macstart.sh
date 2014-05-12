mysql.server start
nginx
unicorn -c unicorn.rb -E development -D
