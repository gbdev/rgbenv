#!/usr/bin/env bats

load _helper

setup_file() {
	setup_file_common
	setup_file_version_cache
}

setup() {
	setup_common
	setup_make_rgbenv
}

check_used_version () {
	rgbasm -V
}

@test "install a version of rgbds, use it, and then disuse it" {
	run rgbenv install 0.5.1
	assert_success
	mv $RGBENV_TEST_VERSIONS/rgbds-0.5.1 $RGBENV_VERSION_CACHE/rgbds-0.5.1
	ln -s $RGBENV_VERSION_CACHE/rgbds-0.5.1 $RGBENV_TEST_VERSIONS/rgbds-0.5.1
	
	run rgbenv use 0.5.1
	assert [ -x "$RGBENV_TEST_DEFAULT/bin/rgbasm" ]
	
	run check_used_version
	assert_line_number -1 "rgbasm v0.5.1"
	
	run rgbenv no-use
	assert [ ! -x "$RGBENV_TEST_DEFAULT/bin/rgbasm" ]
}

@test "uninstall an rgbds version" {
	mv $RGBENV_VERSION_CACHE/rgbds-0.5.1 $RGBENV_TEST_VERSIONS/rgbds-0.5.1
	run rgbenv uninstall 0.5.1
	assert [ ! -x "$RGBENV_TEST_VERSIONS/rgbds-0.5.1/rgbasm" ]
}

@test "remove the rgbenv directories entirely" {
	set +eo pipefail && yes | rgbenv remove
	assert [ ! -d "$RGBENV_TEST_VERSIONS" ]
	assert [ ! -d "$RGBENV_TEST_DEFAULT" ]
}
