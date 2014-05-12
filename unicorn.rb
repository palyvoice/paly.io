home = ENV['PALYIO_HOME_DIR']
working = ENV['PALYIO_WORKING_DIR']

@dir = "#{home}/#{working}"

puts @dir

worker_processes 64
working_directory @dir

timeout 30

listen "#{@dir}tmp/sockets/unicorn.sock", :backlog => 64

pid "#{@dir}tmp/pids/unicorn.pid"

stderr_path "#{home}/log/unicorn.stderr.log"
stdout_path "#{home}/http/log/unicorn.stdout.log"
