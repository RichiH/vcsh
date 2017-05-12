#!/bin/bash

test_description='Foreach command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Foreach requires an argument' \
	'test_must_fail $VCSH foreach'

test_done
