#!/bin/bash

test_description='Run/enter commands'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Run can be abbreviated (ru)' \
	'$VCSH clone -b "$TESTBR1" "$TESTREPO" foo &&

	git ls-remote "$TESTREPO" "refs/heads/$TESTBR1" | cut -f 1 >expected &&
	$VCSH ru foo git rev-parse HEAD >output &&
	test_cmp expected output'

test_done
