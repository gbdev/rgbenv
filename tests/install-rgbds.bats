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

get_nonexistent_version() {
	rgbenv install 0.6.9
}

use_nonexistent_version() {
	rgbenv use 0.6.9
}

get_old_version() {
	rgbenv install 0.5.1
}

@test "fail on getting nonexistent version" {
	run get_nonexistent_version
	assert_fail
}

@test "fail on using nonexistent version" {
	run use_nonexistent_version
	assert_fail
}

@test "get a version" {
	run get_old_version
	assert_success
# move version to cache so we don't have to re-download it each time
	mv $RGBENV_TEST_VERSIONS/rgbds-0.5.1 $RGBENV_VERSION_CACHE/rgbds-0.5.1
	ln -s $RGBENV_VERSION_CACHE/rgbds-0.5.1 $RGBENV_TEST_VERSIONS/rgbds-0.5.1
}

@test "verify correct rgbasm version" {
	ln -s $RGBENV_VERSION_CACHE/rgbds-0.5.1 $RGBENV_TEST_VERSIONS/rgbds-0.5.1
	rgbenv use 0.5.1
	assert [ -x "$RGBENV_TEST_DEFAULT/bin/rgbasm" ]
	assert [ "$(rgbasm -V)" = "rgbasm v0.5.1" ]
}

@test "verify correct rgblink version" {
	ln -s $RGBENV_VERSION_CACHE/rgbds-0.5.1 $RGBENV_TEST_VERSIONS/rgbds-0.5.1
	rgbenv use 0.5.1
	assert [ -x "$RGBENV_TEST_DEFAULT/bin/rgblink" ]
	assert [ "$(rgblink -V)" = "rgblink v0.5.1" ]
}

@test "verify correct rgbgfx version" {
	ln -s $RGBENV_VERSION_CACHE/rgbds-0.5.1 $RGBENV_TEST_VERSIONS/rgbds-0.5.1
	rgbenv use 0.5.1
	assert [ -x "$RGBENV_TEST_DEFAULT/bin/rgbgfx" ]
	assert [ "$(rgbgfx -V)" = "rgbgfx v0.5.1" ]
}

@test "install two RGBDS versions" {
# ...but redownload versions anyway, just for this:
	rgbenv install 0.5.1
	rgbenv install 0.6.1

# save 0.6.1 for later
	mv $RGBENV_TEST_VERSIONS/rgbds-0.6.1 $RGBENV_VERSION_CACHE/rgbds-0.6.1
	ln -s $RGBENV_VERSION_CACHE/rgbds-0.6.1 $RGBENV_TEST_VERSIONS/rgbds-0.6.1

# check directory exists
	assert [ -d "$RGBENV_TEST_VERSIONS/rgbds-0.5.1" ]
	assert [ -d "$RGBENV_TEST_VERSIONS/rgbds-0.6.1" ]
}

check_v051 () {
	rgbenv exec -v 0.5.1 rgbasm -V
}

check_v061 () {
	rgbenv exec -v 0.6.1 rgbasm -V
}

@test "verify exec with two different RGBDS versions" {
	ln -s $RGBENV_VERSION_CACHE/rgbds-0.5.1 $RGBENV_TEST_VERSIONS/rgbds-0.5.1
	ln -s $RGBENV_VERSION_CACHE/rgbds-0.6.1 $RGBENV_TEST_VERSIONS/rgbds-0.6.1
	
	run check_v051
	assert_line_number 1 "rgbasm v0.5.1"
	
	run check_v061
	assert_line_number 1 "rgbasm v0.6.1"
}

compile_v051_051 () {
	rgbasm -i $RGBENV_TESTS_ROOT/asm $RGBENV_TESTS_ROOT/asm/0.5.1.asm
}

compile_v061_061 () {
	rgbasm -I $RGBENV_TESTS_ROOT/asm $RGBENV_TESTS_ROOT/asm/0.6.1.asm
}

compile_v061_051 () {
	rgbasm -i $RGBENV_TESTS_ROOT/asm $RGBENV_TESTS_ROOT/asm/0.6.1.asm
}

@test "compile with two different RGBDS versions" {
	ln -s $RGBENV_VERSION_CACHE/rgbds-0.5.1 $RGBENV_TEST_VERSIONS/rgbds-0.5.1
	ln -s $RGBENV_VERSION_CACHE/rgbds-0.6.1 $RGBENV_TEST_VERSIONS/rgbds-0.6.1
	
	rgbenv use 0.5.1
	run compile_v051_051
	assert_success
	
	rgbenv use 0.6.1
	run compile_v061_061
	assert_success
}

@test "fail compiling on mismatching versions" {
	ln -s $RGBENV_VERSION_CACHE/rgbds-0.5.1 $RGBENV_TEST_VERSIONS/rgbds-0.5.1
	ln -s $RGBENV_VERSION_CACHE/rgbds-0.6.1 $RGBENV_TEST_VERSIONS/rgbds-0.6.1
	
	rgbenv use 0.5.1
	run compile_v061_051
	assert_fail

# pret's rgbasm checks only fails backwards (e.g. 0.5.x checks fail in 0.4.x, but
# not vice versa). is it worth checking in the other direction anyway?
}
