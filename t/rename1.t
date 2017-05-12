#!/bin/bash

test_description='Rename command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Repository to be renamed must exist' \
	'test_must_fail $VCSH rename foo bar'

test_done
