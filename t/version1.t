#!/bin/bash

test_description='Version command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Version command prints vcsh and git versions' \
	'$VCSH version >output &&
	sed -n 1p output | assert_grep "^vcsh [0-9]" &&
	sed -n 2p output | assert_grep "^git version [0-9]"'

test_done
