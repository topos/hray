namespace :hp do
    HP_URL = 'http://www.haskell.org/platform/download/2013.2.0.0/haskell-platform-2013.2.0.0.tar.gz'
    HP_TAR = "/var/tmp/#{HP_URL.split('/').last}"
    HP_DIR = "/var/tmp/#{HP_URL.split('/').last.split('.tar').first}"

    desc "install hp from source"
    task :install => [:build] do
        sh "cd #{HP_DIR} && sudo make install"
    end

    task :build => [:pkgs, HP_DIR] do
        sh "cd #{HP_DIR} && make -j 8"
    end

    HP_PKGS = 'zlib1g-dev libgl1-mesa-dev libglc-dev freeglut3-dev libedit-dev libglw1-mesa libglw1-mesa-dev'

    task :pkgs do
        sh "sudo apt-get install -y #{HP_PKGS}"
    end

    directory HP_DIR => HP_TAR do |t| 
        sh "cd /var/tmp && tar xf #{HP_TAR}"
        sh "cd #{HP_DIR} && ./configure --prefix=/opt/ghc --with-ghc=/opt/ghc/bin/ghc"
    end

    file HP_TAR do |t|
        sh "wget -c -O #{t.name} #{HP_URL}"
    end

    task :clean do
        [HP_TAR,HP_DIR].each do |d|
            sh "rm -rf #{d}"
        end
    end
end
