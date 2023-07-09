.PHONY: test

test: bats
	PATH="./bats/bin:$$PATH" bats tests

bats:
	git clone --depth 1 --branch v1.9.0 https://github.com/bats-core/bats-core.git bats
