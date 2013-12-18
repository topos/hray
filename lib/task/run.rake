namespace :run do
    desc "run main"
    task :run, [:arg] do |t,arg| 
        arg.with_defaults(arg: '')
        Dir.chdir(SRC_DIR) do
            ENV['LD_LIBRARY_PATH'] = EXTRA_LIB_DIR
            puts "LD_LIBRARY_PATH=#{EXTRA_LIB_DIR}"
            sh "./Main #{arg.arg}"
        end
    end
end


