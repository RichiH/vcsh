#!/bin/bash

test_description='Pull command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'pull works with no repositories' \
	'$VCSH pull >output &&
	test_must_be_empty output'

test_done
