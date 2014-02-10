#
# Makefile to setup personal linux environment
#

#no_targets__:
.PHONY: all personal dev development editors awesome post

all: clear personal awesome development editors install

list:
	@grep '^[^#[:space:]].*:' Makefile | grep -Ev 'no_targets__:|list:'

clean:
	@bash ./setup.sh clean

clear:
	@bash ./setup.sh clear

post:
	@bash ./setup.sh post

personal:
	@echo "> Setting up Personal software"
	@bash ./setup.sh personal

awesome:
	@echo "> Setting up AwesomeWM"
	@bash ./setup.sh awesome

dev: development
development:
	@echo "> Setting up Development software"
	@bash ./setup.sh development

editors:
	@echo "> Setting up Editors"
	@bash ./setup.sh editors

install:
	@echo "> Installing selected packages"
	bash ./setup.sh install
