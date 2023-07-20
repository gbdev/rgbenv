setup_file_common() {
	# Setup rgbenv test dirs for one suite
	RGBENV_TESTS_ROOT="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
	
	export RGBENV_TEST_DIR="$BATS_TMPDIR/rgbenv"
	mkdir -p $RGBENV_TEST_DIR
	
	export PATH="$RGBENV_TESTS_ROOT/..:$PATH"
	export RGBENV_TESTS_ROOT
}

setup_file_version_cache() {
	# Setup version cache dirs for one suite
	export RGBENV_VERSION_CACHE="$RGBENV_TEST_DIR/_version_cache"
	mkdir $RGBENV_VERSION_CACHE
}

setup_common() {
	# Set a random "$HOME" for each individual test
	export HOME=$(mktemp -d "$RGBENV_TEST_DIR/XXXXXX")
}

setup_make_rgbenv() {
	# Simulate a minimum rgbenv install for each individual test
	export XDG_DATA_HOME=""
	
	export RGBENV_TEST_VERSIONS=$HOME/.rgbenv/versions
	export RGBENV_TEST_DEFAULT=$HOME/.rgbenv/default
	
	mkdir -p $RGBENV_TEST_VERSIONS
	mkdir -p $RGBENV_TEST_DEFAULT/bin
	
	export PATH=$RGBENV_TEST_DEFAULT/bin:$PATH
}

teardown() {
	rm -rf $HOME
}

teardown_file() {
	rm -rf $RGBENV_TEST_DIR
}

assert() {
	if ! "$@"; then printf "$output"; return 1; fi
}

assert_success() {
	if (( status != 0 )); then printf "(failed with return code $status)\n$output"; return 1; fi
}

assert_fail() {
	if (( status == 0 )); then printf "$output"; return 1; fi
}

assert_line_number () {
	assert [ "${lines[$1]}" = "$2" ]
}
