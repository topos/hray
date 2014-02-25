# cabal:init seems to create ~/.ghc directory in addiction to .cabal (i dunno)
namespace :cabal do
  desc "install cabal-sandbox packages"
  task :install, [:cabal] => [:init] do |t,arg|
    arg.with_defaults(opts: '')
    pkgs = `rake cabal:list`.split("\n").map{|l|l.strip.split.join('-')}
    Dir.chdir(PROJ_DIR) do
      pkg_list = []
      File.readlines('./lib/cabal.list').map{|l|l.strip}.each do |cabal_pkg|
        next if cabal_pkg =~ /^\s*#.*$/ || cabal_pkg =~ /^\s*$/
        cabal, pkgs = cabal_pkg.split('|')
        sh "sudo apt-get install -y #{pkgs}" unless pkgs.nil? || pkgs == ""
        cabals = `cabal list --installed --simple-output`.split("\n").map{|l|l.split.join('-')}
        unless cabals.include?(cabal)
          pkg_list << cabal
        else
          puts "#{cabal} " + "already installed".yellow
        end
      end
      if pkg_list.size > 0
        sh "cabal update"
        pkg_list.each do |pkg|
          next if pkg.start_with?("yesod-bin-") && File.exists?("#{CABAL_SANDBOX_DIR}/bin/yesod")
          if platform?('linux')
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
  task :init, [:force] do |t,arg|
    unless Dir.exists?("#{PROJ_DIR}/.cabal-sandbox") && arg[:force].nil?
      Dir.chdir(PROJ_DIR) do
        task('cabal:sandbox').invoke
        task('cabal:install').invoke
      end
    end
  end

  task :sandbox do
    sh "cabal update"
    sh "cabal install cabal-install"
    sh "cabal sandbox init"
    #sh "cabal install --only-dependencies"
  end

  task :compile_cabal do
    Dir.chdir('/var/tmp') do
      sh "wget http://www.haskell.org/cabal/release/cabal-1.18.1.2/Cabal-1.18.1.2.tar.gz"
      sh "tar xpf Cabal-1.18.1.2.tar.gz"
      Dir.chdir('Cabal-1.18.1.2') do
        sh "ghc --make Setup"
        sh "./Setup configure --global --prefix=/opt/ghc"
        sh "./Setup build"
        sh "./Setup install"
      end
    end
  end

  task :compile_cabal_install do
    Dir.chdir('/var/tmp') do
      sh "wget http://www.haskell.org/cabal/release/cabal-install-1.18.0.2/cabal-install-1.18.0.2.tar.gz"
      sh "tar xpf cabal-install-1.18.0.2.tar.gz"
      Dir.chdir('cabal-install-1.18.0.2') do
        sh "ghc --make Setup"
        sh "./Setup configure --global --prefix=/opt/ghc"
        sh "./Setup build"
        sh "./Setup install"
      end
    end
  end

  desc "install only dependencies"
  task :install_dependencies do
    sh "cabal install --only-dependencies"
  end

  desc "info"
  task :info do
    version('cabal')
  end

  desc "clobber (remove) your cabal sandbox"
  task :clobber do
    begin
      if Dir.exists? SANDBOX_DIR
        Dir.chdir(PROJ_DIR) do
          sh "cabal sandbox delete || exit 0"
        end
      else
        puts "#{SANDBOX_DIR} doesn't exist".red
        puts "manually removing cabal sandbox".yellow
      end
    ensure
      sh "rm -rf #{SANDBOX_DIR}"
      sh "rm -f #{PROJ_DIR}/cabal.sandbox.config"
    end
  end
end
