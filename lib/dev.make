all:
	sudo gem install rake bundler
	bundle install
	rake dev:init
