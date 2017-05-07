#!/bin/bash

test_description='Delete command'

. test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Deleted repository removed from list' \
	'$VCSH init foo &&
	$VCSH init bar &&
	doit | $VCSH delete foo &&

	$VCSH list >output &&
	echo bar >expected &&
	test_cmp expected output'

test_done
