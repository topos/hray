namespace :lxc do
    desc "start an lx container"
    task :start, [:name,:state] do |t,arg|
        raise "error: lxc \"name\" is required" if arg.name.nil?
        3.times do
            begin
                sh "sudo lxc-start -d -n #{arg.name}"
            rescue
                sleep 3
                retry
            end
            break
        end
        sh "sudo lxc-wait -n #{arg.name} -s #{arg.state}" unless arg.state.nil?
    end

    desc "stop an lx container gracefully or immediately"
    task :stop, [:name] do |t,arg|
        raise "error: lxc \"name\" is required" if arg.name.nil?
        arg.with_defaults(stop:false)
        unless arg.stop
            gracetime = 10
            sh "sudo lxc-shutdown -t #{gracetime} -n #{arg.name}"
        else
            sh "sudo lxc-stop -n #{arg.name}"
        end
    end

    desc "stop any lx container in a running state"
    task :startall, [:match] do |t,arg| 
        arg.with_defaults(match: nil)
        match = arg.match
        `sudo lxc-ls --stopped`.strip.split(/\s+/).each do |name|
            if match.nil? || name.start_with?(match)
                task('lxc:start').reenable
                task('lxc:start').invoke(name)
            end
        end
    end

    desc "start any lx container in a running state"
    task :stopall, [:match] do |t,arg| 
        arg.with_defaults(match: nil)
        match = arg.match
        `sudo lxc-ls --running`.strip.split(/\s+/).each do |name|
            if match.nil? || name.start_with?(match)
                task('lxc:stop').reenable
                task('lxc:stop').invoke(name)
            end
        end
    end

    desc "detroy any lx container in a stopped state"
    task :destroyall, [:match] do |t,arg| 
        arg.with_defaults(match: nil)
        match = arg.match
        `sudo lxc-ls --stopped`.strip.split(/\s+/).each do |name|
            if match.nil? || name.start_with?(match)
                task('lxc:destroy').reenable
                task('lxc:destroy').invoke(name)
            end
        end
    end

    desc "a synonym for lxc:attach"
    task :exec, [:name,:cmd] => :attach

    desc "exec a command in a container"
    task :attach, [:name,:cmd] do |t,arg|
        raise "error: \"name\" and/or \"command\" missing" if arg.name.nil? || arg.cmd.nil?
        sh "sudo lxc-attach -n #{arg.name} -- #{arg.cmd}"
    end

    desc "install packages"
    task :install, [:name,:packages] do |t,arg|
        raise "error: lxc \"name\" is required" if arg.name.nil?
        task("lxc:exec").reenable
        task("lxc:exec").invoke(arg.name,'sudo apt-get update -y')
        arg.packages.split(/\s+/).map{|pkg|"sudo apt-get install -y #{pkg}"}.each do |cmd|
            task("lxc:exec").reenable
            task("lxc:exec").invoke(arg.name,cmd)
        end
    end

    desc "login"
    task :login, [:name] do |t,arg|
        raise "error: lxc \"name\" is required" if arg.name.nil?
        sh "sudo lxc-console -n #{arg.name}"
    end

    desc "list"
    task :ls => :list
    task :list do
        sh "sudo lxc-ls --fancy"
    end

    desc "lxc ps"
    task :ps, [:opt] do |t,arg|
        if arg.option.nil?
            sh "sudo lxc-ps -n plain"
        else
            sh "sudo lxc-ps -n plain -- #{arg.option}"
        end
    end

    desc "ssh"
    task :ssh, [:name] do |t,arg|
        raise "error: lxc \"name\" is required" if arg.name.nil?
        ip = `sudo lxc-ls --fancy|grep '#{arg.name}'|awk '{print $3}'`.strip
        sh "ssh #{ip}"
    end

    desc "configure an LXC so ssh doesn't require a password"
    task :dotssh, [:name] do |t,arg|
        raise "error: name undefined".red if arg.name.nil?
        lxcs = if ":all" == arg.name
                   `sudo lxc-ls -1`.lines.each.map{|l|l.strip}
               else
                   [arg.name]
               end
        lxcs.each do |name|
            ip = lxc2ip name
            puts name
            puts ip
            puts "=============="
            sh "ssh-copy-id ubuntu@#{ip}"
            cmd = [] << "sort ~/.ssh/authorized_keys|uniq > /var/tmp/authorized_keys"
            cmd << "mv -f /var/tmp/authorized_keys ~/.ssh"
            sh "ssh ubuntu@#{ip} '#{cmd.join(' && ')}'"
        end
    end

    desc "destroy lx container"
    task :destroy, [:name,:force] do |t,arg|
        raise "error: lxc \"name\" is required" if arg.name.nil?
        unless arg.force.nil?
            sh "rake lxc:stop[#{arg.name}]"
        end
        sh "sudo lxc-destroy -n #{arg.name}"
    end

    task :create => :make
    desc "make a linux container--defaults:linux/<current release>"
    task :make, [:name,:template,:release,:hack] do |t,arg|
        arg.with_defaults(name: "linux",template: "ubuntu",release: nil,hack: nil)
        cmd = [] << "lxc-create -t ubuntu -n #{arg.name}"
        cmd << "-- -r #{arg.release}" unless arg.release.nil?
        sh "sudo #{cmd.join(' ')}"
        sh "sudo lxc-wait -n #{arg.name} -s STOPPED" unless arg.state.nil?
        sh "rake lxc:start[#{arg.name}]"
        sh "sudo lxc-wait -n #{arg.name} -s RUNNING" unless arg.state.nil?
        sh "rake lxc:install_packages[#{arg.name},lxc,'--no-install-recommends']"
        sh "rake lxc:sudo_access[#{arg.name},ubuntu]"
        if arg.hack.nil?
            sh "rake lxc:dotssh[#{arg.name}]"
        else
            Dir.chdir("/var/lib/lxc/#{arg.name}/rootfs/home/ubuntu") do
                sh "sudo tar xpf #{TASK_DIR}/dotssh.tar.gz"
                sh "sudo chown -R 1000:1000 .ssh"
                sh "cp ~/.ssh/id_rsa.pub /var/tmp"
                sh " ~/.ssh/id_rsa.pub /var/tmp"
            end
        end
    end

    desc "give sudo access to a user on an lxc name"
    task :sudo_access, [:name,:user] do |t,arg|
        raise "error: :name and :user are undefined" if arg.name.nil? || arg.user.nil?
        task("lxc:exec").invoke(arg.name,"/bin/sh -c \"echo '#{arg.user}  ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/#{arg.user}\ && chmod 0440 /etc/sudoers.d/#{arg.user}\"")
    end

    task :install_packages, [:name,:packages,:opt] do |t,arg|
        unless arg.name.nil? || arg.packages.nil?
            pkgs = arg.packages.split(',').map{|p|p.strip}
            sh "sudo chroot /var/lib/lxc/#{arg.name}/rootfs apt-get update -y"
            pkgs.each do |pkg| 
                begin
                    sh "sudo chroot /var/lib/lxc/#{arg.name}/rootfs apt-get install -y #{arg.opt||''} #{pkg}"
                rescue => x
                    puts x
                end
            end
        else
            puts "warning [noop]: \"name\" and/or \"packages\" missing"
        end
    end

    desc "initialize/install lxc"
    task :init => [:install,:network_config]

    desc "install lxc"
    task :install do
        sh "sudo aptitude update -y"
        sh "sudo aptitude install -y lxc"
    end

    desc "configure outbound IP traffic from a container"
    task :network_config do
        # ! may not be needed anymore
        # dotdir =   File.expand_path(File.dirname(__FILE__))
        # if File.exists?("/etc/lxc/default.conf") && !File.exists?("/etc/lxc/default.conf.orig")
        #   Dir.chdir("/etc/lxc") do
        #     sh "sudo mv -f default.conf default.conf.orig"
        #   end
        # end
        # sh "sudo cp #{dotdir}/lxc_default.conf /etc/lxc/default.conf"
    end

    # @todo: automate
    desc "configure bridge network on primary host"
    task :bridge_network do
        puts "- append the following to /etc/network/interfaces:"
        puts "auto lxcbr0"
        puts "iface br0 inet static"
        puts "    bridge_ports eth0"
        puts "    bridge_stp off"
        puts "    bridge_fd 0"
        puts "    bridge_maxwait 0"
        puts "- and comment out \"eth0\" fragment"
    end

    def lxc2ip(name)
        ip = `sudo lxc-ls --fancy|egrep '^#{name}\s+'|awk '{print $3}'`.strip
        ip
    end   
end
