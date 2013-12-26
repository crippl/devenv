#
# Makefile to setup personal linux environment
#

no_targets__:
.PHONY: all personal dev development editors awesome

list:
	@grep '^[^#[:space:]].*:' Makefile | grep -Ev 'no_targets__:|list:'

all: clear personal development editors install

clean:
	@bash ./setup.sh clean

clear:
	@bash ./setup.sh clear

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
