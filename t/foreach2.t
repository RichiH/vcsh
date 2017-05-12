#!/bin/bash

test_description='Foreach command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Foreach executes Git command inside each repository' \
	'$VCSH clone -b "$TESTBR1" "$TESTREPO" foo &&
	$VCSH clone -b "$TESTBR2" "$TESTREPO" bar &&

	{
		echo "bar:" &&
		git ls-remote "$TESTREPO" "refs/heads/$TESTBR2" | cut -f 1 &&
		echo "foo:" &&
		git ls-remote "$TESTREPO" "refs/heads/$TESTBR1" | cut -f 1
	} >expected &&

	$VCSH foreach rev-parse HEAD >output &&
	test_cmp expected output'

test_done
