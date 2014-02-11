namespace :cabal do
    desc "install cabal-sandbox packages"
    task :install, [:cabal] => [:init] do |t,arg|
        arg.with_defaults(opts: '')
        pkgs = `rake cabal:list`.split("\n").map{|l|l.strip.split.join('-')}
        Dir.chdir(PROJ_DIR) do
            pkg_list = []
            File.readlines('./lib/cabal.list').map{|l|l.strip}.each do |pkg|
                next if pkg =~ /^\s*#.*$/ || pkg =~ /^\s*$/
                unless pkgs.include?(pkg)
                    pkg_list << pkg
                else
                    puts "#{pkg} " + "already installed".green
                end
            end
            if pkg_list.size > 0
                sh "cabal update"
                pkg_list.each do |pkg|
                    next if pkg.start_with?("yesod-bin-") && File.exists?("#{CABAL_SANDBOX_DIR}/bin/yesod")
                    if platform?('linux')
                        # hmatrix is depedent on libgsl0-dev and liblapack-dev
                        # not sure where else to the do the following
                        if pkg.include?("hmatrix-")
                            sh "sudo apt-get install -y libgsl0-dev liblapack-dev gnuplot imagemagick"
                        end
                        sh "cabal install --extra-include-dirs=#{OPT_DIR}/zmq/include --extra-lib-dirs=#{OPT_DIR}/zmq/lib #{pkg}"
                    elsif platform?('darwin')
                        sh "cabal install #{pkg}"
                    else
                        raise "unrecognized platform"
                    end
                end
            end
        end
    end

    desc "list cabal-sandbox packages"
    task :list, [:cabal,:remote] do |t,arg|
        Dir.chdir(PROJ_DIR) do
            if arg.cabal.nil?
                sh "cabal list --verbose --installed --simple-output"
            else
                if arg.remote.nil?
                    sh "cabal list --verbose --installed --simple-output #{arg.cabal}"
                else
                    sh "cabal list --verbose --simple-output #{arg.cabal}"
                end
            end
        end
    end

    desc "init. your cabal sandbox"
    task :init do
        unless Dir.exists? "#{PROJ_DIR}/.cabal-sandbox"
            Dir.chdir(PROJ_DIR) do
                sh "cabal install cabal-install"
                sh "cabal update"
                sh "cabal sandbox init"
            end
        end
    end


    desc "install only dependencies"
    task :install_dependencies do
        sh "cabal install --only-dependencies"
    end

    desc "clobber (remove) your cabal sandbox"
    task :clobber do
        if Dir.exists? SANDBOX_DIR
            Dir.chdir(PROJ_DIR) do
                begin
                    sh "cabal sandbox delete"
                ensure
                    sh "rm -rf #{SANDBOX_DIR}"
                end
            end
        else
            puts "noop: #{SANDBOX_DIR} doesn't exist".yellow
        end
    end
end
