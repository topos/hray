namespace :cluster do
    desc "start a cluster on dev for testing"
    task :start  do
        sh "#{SRC_DIR}/Main slave localhost 9000 &"
        sh "#{SRC_DIR}/Main slave localhost 9001 &"
        sh "#{SRC_DIR}/Main slave localhost 9002 &"
        puts "slaves started".green
        sh "#{SRC_DIR}/Main master localhost 8000 &"
    end

    desc "add an actor to the cluster started via rake cluster:start"
    task :add, [:port]  do |t,arg|
        raise "arg.port is undefined" if arg.port.nil?
        sh "#{SRC_DIR}/Main slave localhost #{arg.port} &"
    end
end
