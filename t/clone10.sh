#!/bin/bash

test_description='Clone command'

. test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Clone -b option clones only one branch' \
	'$VCSH clone -b "$TESTBR1" "$TESTREPO" &&
	$VCSH run "$TESTREPONAME" git branch >output &&
	test_line_count = 1 output'

test_done
