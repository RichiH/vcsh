#!/bin/bash

test_description='Clone command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Clone requires a remote' \
	'test_must_fail $VCSH clone'

test_done
