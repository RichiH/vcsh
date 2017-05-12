#!/bin/bash

test_description='Which command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Which command fails if pattern not found' \
	'$VCSH init foo &&

	touch a &&
	$VCSH foo add a &&
	$VCSH foo commit -m "a" &&

	test_must_fail $VCSH which nope'

test_done
