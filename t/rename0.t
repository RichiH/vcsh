#!/bin/bash

test_description='Rename command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Rename requires two arguments' \
	'test_must_fail $VCSH rename &&
	test_must_fail $VCSH rename foo'

test_done
