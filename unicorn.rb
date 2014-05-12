home = ENV['PALYIO_HOME_DIR']
working = ENV['PALYIO_WORKING_DIR']
procs = ENV['PALYIO_PROCESSES'].to_i

@dir = "#{home}#{working}"

worker_processes procs
working_directory @dir

timeout 30

listen "#{@dir}tmp/sockets/unicorn.sock", :backlog => 64

pid "#{@dir}tmp/pids/unicorn.pid"

stderr_path "#{home}log/unicorn.stderr.log"
stdout_path "#{home}log/unicorn.stdout.log"
