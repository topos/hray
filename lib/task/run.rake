namespace :run do
    desc "run Main or generally Spec"
    task :run, [:options] do |t,arg| 
        arg.with_defaults(options: "Main #{arg.options}".strip)
        puts SRC_DIR_
        Dir.chdir(SRC_DIR) do
            ENV['LD_LIBRARY_PATH'] = EXTRA_LIB_DIR
            puts "LD_LIBRARY_PATH=#{EXTRA_LIB_DIR}"
            sh "#{arg.options} LD_LIBRARY_PATH=#{EXTRA_LIB_DIR}"
        end
    end
end
