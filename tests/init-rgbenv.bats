#!/usr/bin/env bats

load _helper

setup_file() {
	setup_file_common
}

setup() {
	setup_common
}

@test "init rgbenv at ~/.rgbenv" {
	export XDG_DATA_HOME=""
	set +o pipefail && yes | rgbenv
	
	assert [ -d "$HOME/.rgbenv" ]
	assert [ -d "$HOME/.rgbenv/versions" ]
	assert [ -d "$HOME/.rgbenv/default" ]
}

@test "init rgbenv at \$XDG_DATA_HOME/rgbenv" {
	export XDG_DATA_HOME="$HOME/data"
	mkdir $XDG_DATA_HOME # requires the dir to exist first
	set +o pipefail && yes | rgbenv
	
	assert [ -d "$XDG_DATA_HOME/rgbenv" ]
	assert [ -d "$XDG_DATA_HOME/rgbenv/versions" ]
	assert [ -d "$XDG_DATA_HOME/rgbenv/default" ]
}

@test "if \$XDG_DATA_HOME defined, offer to move ~/.rgbenv there" {
	mkdir $HOME/.rgbenv
	
	export XDG_DATA_HOME="$HOME/data"
	mkdir $XDG_DATA_HOME
	
	assert [ ! -d "$XDG_DATA_HOME/rgbenv" ]
	
	set +o pipefail && yes | rgbenv # should offer to move the directory there
	
	assert [ ! -d "$HOME/.rgbenv" ]
	assert [ -d "$XDG_DATA_HOME/rgbenv" ]
}
