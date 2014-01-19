namespace :ghc do
    GHC_URL = 'http://www.haskell.org/ghc/dist/7.6.3/ghc-7.6.3-src.tar.bz2'
    GHC_TAR = "/var/tmp/#{GHC_URL.split('/').last}"
    GHC_DIR = "/var/tmp/#{GHC_URL.split('/').last.split('-src').first}"

    desc "install ghc from source"
    task :install => [GHC_DIR] do
        Dir.chdir(GHC_DIR) do
            sh "sudo make install"
        end
    end

    task :build => [:pkgs, GHC_DIR] do
        Dir.chdir(GHC_DIR) do
            sh "make -j 8"
        end
    end

    task :pkgs do
        sh "sudo apt-get install ncurses-dev"
    end

    directory GHC_DIR => GHC_TAR do |t| 
        Dir.chdir('/var/tmp') do
            sh "tar xf #{GHC_TAR}"
        end
        Dir.chdir(GHC_DIR) do
            sh "./configure --prefix=/opt/ghc CFLAGS=-O2"
        end
    end

    file GHC_TAR do |t|
        sh "wget -c -O #{t.name} #{GHC_URL}"
    end

    task :clean do
        [GHC_TAR,GHC_DIR].each do |d|
            sh "rm -rf #{d}"
        end
    end
end
