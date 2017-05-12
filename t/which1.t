#!/bin/bash

test_description='Which command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Which command does not accept an empty parameter' \
	'test_must_fail $VCSH which ""'

test_done
