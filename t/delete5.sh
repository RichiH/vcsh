#!/bin/bash

test_description='Delete command'

. test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Deleted repository not in status' \
	'$VCSH init foo &&
	doit | $VCSH delete foo &&

	$VCSH status >output &&
	test_line_count = 0 output'

test_done
