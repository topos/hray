namespace :db do
  require File.expand_path("#{File.dirname(__FILE__)}/dev.rb")

  POSTGRES = YAML.load_file("#{PROJ_DIR}/etc/postgresql.yml")
  P = POSTGRES[proj_mode]

  if `uname` == "Darwin"
    ENV['PATH'] = "/opt/local/bin:#{ENV['PATH']}"
  end

  desc "initialize user and database"
  task :init, [:db] => [:user, :database]

  desc "create database"
  task :database, [:db] do |t, arg|
    arg.with_defaults(:username => P['user'], :database => P['database'])
    c = [] << "createdb" 
    c << "--owner=#{arg.username}"
    c << "--template=template1"

    sh "sudo su - postgres -c '#{c.join(' ')} #{arg.database}'"
    if proj_mode == 'Development'
      sh "sudo su - postgres -c '#{c.join(' ')} #{POSTGRES['Testing']['database']}'"
    end
  end

  desc "create database user"
  task :user, [:login, :password]  do |t, arg|
    arg.with_defaults(:username => P['user'], :password => P['password'])
    sql = "create user #{arg.username} with password '#{arg.password}' nosuperuser createdb createrole;"
    psql(sql)
  end

  desc "log into db as user=postgres"
  task :sqlp do
    sh "sudo -E su - postgres -c 'psql'"
  end

  desc "log into db as user=klas"
  task :sqlu do
    ENV['PGUSER'] = P['user']
    ENV['PGPASSWORD'] = P['password']
    ENV['PGDATABASE'] = P['database']
    ENV['PGHOST'] = P['host']
    sh "sudo -E su postgres -c psql"
  end
  
  desc "start postgres"
  task :start, [:verbose] do |t, arg|
    unless process_running?('postgres')
      sh "sudo /etc/init.d/postgresql start"
    else
      puts "postgresql is already running".yellow
    end
  end    

  desc "start postgres"
  task :stop do
    if process_running?('postgres')
      sh "sudo /etc/init.d/postgresql stop"
    else
      puts "postgresql isn't running".yellow
    end
  end    

  desc "start postgres"
  task :restart do
    sh "sudo su - postgres -c 'pg_ctl restart'"
  end    

  desc "backup postgres"
  task :backup do
    DB_DIR = '/var/backups/db"'
    if File.exists?(DB_DIR)
      sh "sudo chmod a+rx /var/backups"
      sh "sudo mkdir -p /var/backups/db"
      sh "sudo chmod g+rwx /var/backups/db && sudo chmod o+t /var/backups/db"
      sh "sudo chown postgres /var/backups/db && sudo chgrp staff /var/backups/db"
    end
    t = DateTime.now.strftime('%m-%d-%Y-%H%M%S')
    sh "sudo su - postgres -c 'pg_dumpall > #{DB_DIR}/db-#{t}.dump'"
  end

  desc "info"
  task :info do
    puts POSTGRES
  end

  desc "install"
  task :install do
    unless File.exists?('/etc/apt/sources.list.d/pgdg.list')
      sh "echo 'deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main' > /var/tmp/pgdg.list"
      sh "sudo cp /var/tmp/pgdg.list /etc/apt/sources.list.d"
      sh "wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -"
    end
    #sh "sudo aptitude update -y"
    sh "sudo aptitude install -y postgresql-9.2 "
  end
  
  def psql(sql)
    `echo \"#{sql}\" | sudo su - postgres -c 'psql --file=-'`
  end

  def postgres(cmd ='psql')
    "sudo su - postgres -c '#{cmd}'"
  end
end
