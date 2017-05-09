#!/bin/bash

test_description='Delete command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Repository to be deleted must exist' \
	'test_must_fail $VCSH delete foo'

test_done
