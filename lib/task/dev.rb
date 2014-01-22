require 'rubygems'
require 'bundler/setup'
require 'date'
require 'yaml'
require 'smart_colored/extend'

def platform?(p)
    `uname -s`.strip.downcase == p.downcase
end

def proj_dir(subdir =nil)
    path = [] << PROJ_DIR
    path << subdir unless subdir.nil?
    path.join('/')
end

def process_running?(name, argfilter =nil)
    require 'sys/proctable'
    include Sys
    ProcTable.ps do |proc|
        if argfilter.nil?
            return true if proc.comm == name
        else
            return true if proc.comm == name && proc.cmdline.split.include?(argfilter)
        end
    end
    false
end

def proj_mode
    ENV['PROJ_MODE'].nil? ? 'Development' : ENV['PROJ_MODE']
end

def terminal(cmd ='', opts ='', title ='')
    raise "cmd is undefined" if cmd.nil?
    title = "#{cmd} #{opts}" if title == ''
    "gnome-terminal --title '#{title}' --execute sh -c '#{cmd} #{opts}'"
end

PROJ_DIR = File.expand_path("#{File.dirname(__FILE__)}/../../.")
SRC_DIR = proj_dir('src')
ETC_DIR = proj_dir('etc')
LIB_DIR = proj_dir('lib')
TASK_DIR = proj_dir('lib/task')
OPT_DIR = proj_dir('opt')
SANDBOX_DIR = proj_dir('.cabal-sandbox')
PROJ_HOME = PROJ_DIR

os = `uname -s`.strip.downcase
OS = case os
     when 'darwin'; 'osx'
     when 'linux'; 'linux'
     else raise "unknown OS: #{os}"
     end
GHC_PACKAGE_PATH = "#{PROJ_DIR}/.cabal-sandbox/x86_64-#{OS}-ghc-7.6.3-packages.conf.d"
CABAL_SANDBOX_DIR = "#{PROJ_DIR}/.cabal-sandbox"
EXTRA_INC_DIR = "#{OPT_DIR}/zmq/include"
EXTRA_LIB_DIR = "#{OPT_DIR}/zmq/lib"
EXTRA_INC, EXTRA_LIB = ['#{EXTRA_INC_DIR}',"-L#{EXTRA_LIB_DIR} -lzmq"]
GHC = "ghc -no-user-package-db -package-db #{GHC_PACKAGE_PATH} -threaded"

# ~/.cabal/bin is important since the new version of cabal will go there
_path = []
_path << "#{PROJ_DIR}/bin"
_path << "#{PROJ_DIR}/.cabal-sandbox/bin"
_path << "~/.cabal/bin"
_path << (platform?('darwin') ? '~/Library/Haskell/bin' : '/opt/ghc/bin')
_path << '/usr/local/bin'
_path << '/usr/bin'
_path << '/bin'

ENV['PATH'] = _path.join(':')
