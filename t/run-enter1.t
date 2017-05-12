#!/bin/bash

test_description='Run/enter commands'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

test_expect_success 'Run implied if no explicit command specified' \
	'$VCSH clone -b "$TESTBR1" "$TESTREPO" foo &&
	$VCSH clone -b "$TESTBR2" "$TESTREPO" bar &&

	git ls-remote "$TESTREPO" "refs/heads/$TESTBR1" | cut -f 1 >expected &&
	$VCSH foo rev-parse HEAD >output &&
	test_cmp expected output &&

	git ls-remote "$TESTREPO" "refs/heads/$TESTBR2" | cut -f 1 >expected &&
	$VCSH bar rev-parse HEAD >output &&
	test_cmp expected output'

test_done
