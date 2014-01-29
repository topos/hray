namespace :run do
    desc "run main"
    task :run, [:options] do |t,arg| 
        arg.with_defaults(options: "Main #{arg.options}".strip)
        Dir.chdir(SRC_DIR) do
            ENV['LD_LIBRARY_PATH'] = EXTRA_LIB_DIR
            puts "LD_LIBRARY_PATH=#{EXTRA_LIB_DIR}"
            sh "#{arg.options} LD_LIBRARY_PATH=#{EXTRA_LIB_DIR}"
        end
    end
end
