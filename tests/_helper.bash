
setup_file() {
	DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
	export RGBENV_TEST_DIR="$BATS_TMPDIR/rgbenv"
	mkdir -p $RGBENV_TEST_DIR
	export PATH="$DIR/..:$PATH"
}

setup() {
	export HOME=$(mktemp -d "$RGBENV_TEST_DIR/XXXXXX")
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
