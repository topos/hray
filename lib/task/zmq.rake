namespace :zmq do
    ZMQ_U = 'http://download.zeromq.org/zeromq-4.0.3.tar.gz'
    ZMQ_F = ZMQ_U.split('/').last
    ZMQ_D = ZMQ_F.split('.').first(ZMQ_F.split('.').size-2).join('.')

    desc "start"
    task :start do
        Dir.chdir("#{OPT_DIR}/zmq/jetty") do
            sh "java -Dzmq.zmq.home=docu -jar start.jar"
        end
    end

    directory OPT_DIR

    desc "install zmq"
    task :install => OPT_DIR do
        sh "mkdir -p OPT_DIR" unless Dir.exists?(OPT_DIR)
        Dir.chdir('./opt') do
            task('zmq:init:install').invoke
        end
    end
    
    desc "clobber"
    task :clobber do
        Dir.chdir('opt') do
            sh "rm -rf #{ZMQ_D} #{ZMQ_F}"
        end
    end

    task :info do
        puts "src=#{ZMQ_U}"
    end

    namespace :init do
        file ZMQ_F do
            sh "wget --output-document='#{ZMQ_U.split('/').last}' #{ZMQ_U}"
        end

        directory ZMQ_D => ZMQ_F do
            sh "tar xpf #{ZMQ_F}"
        end

        task :default => :install

        desc "install zmq"
        task :install => ZMQ_D do
            Dir.chdir(ZMQ_D) do
                sh "./configure --prefix=#{OPT_DIR}/zmq"
                sh "make -j 4"
                sh "make install"
            end
            sh "rake zmq:clobber"
        end
    end

    namespace :cabal do
        desc "install zero-mq-4 cabal package"
        task :install do
            Dir.chdir(OPT_DIR) do
                sh "git clone https://github.com/twittner/zeromq-haskell.git" unless Dir.exists?('zeromq-haskell')
            end
            Dir.chdir(PROJ_DIR) do
                sh "cabal sandbox add-source #{OPT_DIR}/zeromq-haskell"
                sh "cabal install --dependencies-only" # install it into sandbox
            end
        end
    end
end

