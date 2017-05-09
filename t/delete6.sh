#!/bin/bash

test_description='Delete command'

. test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Deleted repository cannot be subsequently used' \
	'$VCSH init foo &&
	doit | $VCSH delete foo &&

	test_must_fail $VCSH run foo echo fail'

test_done
