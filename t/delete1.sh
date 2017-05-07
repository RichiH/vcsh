#!/bin/bash

test_description='Delete command'

. test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Delete requires repo name' \
	'test_must_fail $VCSH delete'

test_done
