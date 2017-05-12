#!/bin/bash

test_description='Rename command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Target of rename must not already exist' \
	'$VCSH init foo &&
	$VCSH init bar &&

	test_must_fail $VCSH rename foo bar'

test_done
