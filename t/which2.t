#!/bin/bash

test_description='Which command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Which command fails if no repositories' \
	'test_must_fail $VCSH which nope'

test_done
