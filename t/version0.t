#!/bin/bash

test_description='Version command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Version command succeeds' \
	'$VCSH version'

test_done
