#!/bin/bash

test_description='Which command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Which command requires exactly one parameter' \
	'test_must_fail $VCSH which &&
	test_must_fail $VCSH which foo bar'

test_done
