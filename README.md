devenv
======

This will install about 3gb of software on a fresh Ubuntu installation if all software is selected

On a new installaion of Ubuntu don't forget to run apt-get update before running scripts

### Installation

	sudo apt-get update
	git clone https://github.com/ripply/devenv && cd devenv && make
	
	Or a one liner
	sudo apt-get update && git clone https://github.com/ripply/devenv && cd devenv && make
	
The scripts will prompt to install each piece of software that is reported as installable by apt-cache

At the end of the script, all software will be installed with one big apt-get install command

### Included Software

	git
	C++ Build essentials
	C++ Qt Development libraries
	Eclipse-CDT
	Netbeans
	sqlite
	The Latest Android Development Kit Bundle
	Libraries to enable hardware acceleration for the Android Emulator
	JDK1.6
	Emacs/VIM
	
	Dropbox
	Wine
	Gimp
	redshift or f.lux
	vlc
	ubuntu-restricted-extras
	steam
	calibre
	xbmc
	Youtube To Mp3 by MediaHuman
	
	AwesomeWM
	Optionally, clone my AwesomeWM Config file from https://github.com/ripply/awesome-config/ and install it
	
### Extending the scripts to install your own preferred software in a fork

Open any of the [setup.sh](development/setup.sh) scripts in the subfolders and just add

```bash
install "some package names to install" "description to show user"
```

The description is optional, if not given then the names of the packages will be shown

The scripts are run from the main [setup](setup.sh) script so any exported function in that script is usable.
