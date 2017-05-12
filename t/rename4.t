#!/bin/bash

test_description='Rename command'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Rename works on repository with files/commits' \
	'$VCSH clone -b "$TESTBR1" "$TESTREPO" foo &&
	git ls-remote "$TESTREPO" "refs/heads/$TESTBR1" | cut -f 1 >expected &&

	$VCSH rename foo bar &&
	$VCSH bar rev-parse HEAD >output &&
	test_cmp expected output'

test_done
