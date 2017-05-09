#!/bin/bash

test_description='List command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'List command prioritizes $XDG_CONFIG_HOME over $HOME' \
	'test_env HOME="$PWD/foo" $VCSH init correct &&
	test_env HOME="$PWD/bar" $VCSH init wrong &&

	echo correct >expected &&
	test_env HOME="$PWD/bar" XDG_CONFIG_HOME="$PWD/foo/.config" $VCSH list >output &&
	test_cmp expected output'

test_done
