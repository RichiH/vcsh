#!/bin/bash

test_description='Push command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'push works with no repositories' \
	'$VCSH push &>output &&
	test_must_be_empty output'

test_done
