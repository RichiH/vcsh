#!/bin/bash

test_description='Clone command'

. test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Clone honors specified repo name' \
	'$VCSH clone "$TESTREPO" foo &&
	echo foo >expected &&
	$VCSH list >output &&
	test_cmp expected output'

test_done
